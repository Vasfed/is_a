#include "ruby.h"
#include <stdlib.h>
#include <stdio.h>

static VALUE rb_mIsA;


static VALUE
rb_get_class_of(VALUE self, VALUE obj)
{
  VALUE cls = rb_class_of(obj);
  //printf("Class of %lu is %lu\n", obj / 2, cls / 2);
  return cls;
}

static VALUE
rb_object_id_of(VALUE self, VALUE obj)
{
  return rb_obj_id(obj);
}


#ifdef HAVE_VM_CORE_H
#include "ruby/encoding.h"
#include "vm_core.h"

#ifndef ID_ALLOCATOR
#define ID_ALLOCATOR 0
#endif

#ifdef HAVE_RB_ISEQ_LINE_NO
#include "method.h"
#include "iseq.h"

inline static int
calc_lineno(const rb_iseq_t *iseq, const VALUE *pc)
{
    return rb_iseq_line_no(iseq, pc - iseq->iseq_encoded);
}
#define rb_vm_get_sourceline rb_vm_get_sourceline_static
static int rb_vm_get_sourceline_static(const rb_control_frame_t * cfp){
  int lineno = 0;
  const rb_iseq_t *iseq = cfp->iseq;

  if (RUBY_VM_NORMAL_ISEQ_P(iseq)) {
    lineno = calc_lineno(cfp->iseq, cfp->pc);
  }
  return lineno;
}
#endif

#define HAVE_CALLER_AT
static VALUE caller_line(int offset)
{
  const rb_thread_t *th = ((rb_thread_t *)RTYPEDDATA_DATA(rb_thread_current()));
  offset += 2;
  if(offset < 0)
    return Qnil;

  rb_control_frame_t* cfp = th->cfp + offset;
  const rb_control_frame_t* stack_end = (void *)(th->stack + th->stack_size);

  VALUE name = 0;

  while(cfp < stack_end){
    if (cfp->iseq != 0) {
      if (cfp->pc != 0) {
        rb_iseq_t *iseq = cfp->iseq;
        int line_no = rb_vm_get_sourceline(cfp);

        #ifndef HAVE_RB_ISEQ_T_LOCATION
        VALUE file = iseq->filename;
        #else
        VALUE file = iseq->location.path;
        #endif

        //name may be passed from previous iteration
        if(!name)
          name =
          #ifdef HAVE_RB_ISEQ_T_LOCATION
            iseq->location.label;
          #else
            iseq->name;
          #endif

        if (line_no) {
          return rb_enc_sprintf(
                rb_enc_compatible(file, name),
                "%s:%d:in `%s'",
                RSTRING_PTR(file), line_no, RSTRING_PTR(name));
        } else {
          return rb_enc_sprintf(
                rb_enc_compatible(file, name),
                "%s:in `%s'",
                RSTRING_PTR(file), RSTRING_PTR(name));
        }
      }
    } else {
      // for CFUNCs - search for previous ruby frame for location
      if (RUBYVM_CFUNC_FRAME_P(cfp)) {
        if (!name){
          ID id;
          if (cfp->me->def)
            id = cfp->me->def->original_id;
          else
            id = cfp->me->called_id;
          if (id != ID_ALLOCATOR){
            name = rb_id2str(id);
          }
        }
      }
      cfp += 1;
      continue;
    }
    break;
  }

  // level is out of bounds
  return Qnil;
}

static VALUE
rb_caller_line(VALUE self, VALUE r_offset)
{
  int offset = NUM2INT(r_offset); // we are not interested in self
  return caller_line(offset);
}

static VALUE rb_caller_line_global(int argc, VALUE* argv)
{
  VALUE level;
  int lev;

  rb_scan_args(argc, argv, "01", &level);

  if (NIL_P(level))
    lev = 0;
  else
    lev = NUM2INT(level);

  if (lev < 0)
    rb_raise(rb_eArgError, "negative level (%d)", lev);
  return caller_line(lev);
}
#endif

void Init_is_a(){
  rb_mIsA = rb_define_module("IsA");
  rb_define_singleton_method(rb_mIsA, "class_of", rb_get_class_of, 1);
  rb_define_singleton_method(rb_mIsA, "id_of", rb_object_id_of, 1);
#ifdef HAVE_CALLER_AT
  rb_define_singleton_method(rb_mIsA, "caller_line", rb_caller_line, 1);
  rb_define_global_function("caller_line", rb_caller_line_global, -1);
#endif
}
