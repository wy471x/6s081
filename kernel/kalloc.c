// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

#define PA2PPIDX(pa) (((uint64)(pa) - KERNBASE) / PGSIZE)
// reference count for each physical page.
struct {
  struct spinlock lock; // protects freelist
  int refcnt_array[PA2PPIDX(PHYSTOP) + 1]; // reference count for each physical page
} refcnt_recorder;

int refcnt_incr(uint64 pa)
{
  acquire(&refcnt_recorder.lock);
  int refcnt = ++refcnt_recorder.refcnt_array[PA2PPIDX(pa)];
  release(&refcnt_recorder.lock);
  return refcnt;
}

int refcnt_decr(uint64 pa)
{
  acquire(&refcnt_recorder.lock);
  int refcnt = --refcnt_recorder.refcnt_array[PA2PPIDX(pa)];
  release(&refcnt_recorder.lock);
  return refcnt;
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&refcnt_recorder.lock, "refcnt_recorder");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    // acquire(&refcnt_recorder.lock);
    refcnt_recorder.refcnt_array[PA2PPIDX(p)] = 1; // initialize reference count
    // release(&refcnt_recorder.lock);
    kfree(p);
  }
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  int ref = refcnt_decr((uint64)pa);
  if(ref > 0)
    return; // still in use, don't free

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    // acquire(&refcnt_recorder.lock);
    refcnt_recorder.refcnt_array[PA2PPIDX(r)] = 1; // reset reference count
    // release(&refcnt_recorder.lock);
  }  
  release(&kmem.lock);

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
  }
    
  return (void*)r;
}
