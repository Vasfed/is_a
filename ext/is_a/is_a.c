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

#define HAVE_CALLER_AT
static VALUE caller_line(int offset)
{
  const rb_thread_t *th = ((rb_thread_t *)RTYPEDDATA_DATA(rb_thread_current()));
  offset += 2;
  if(offset < 0)
    return Qnil;

  rb_control_frame_t* cfp = th->cfp + offset;
  const rb_control_frame_t* stack_end = (void *)(th->stack + th->stack_size);

  if(cfp < stack_end){
    if (cfp->iseq != 0) {
      if (cfp->pc != 0) {
        rb_iseq_t *iseq = cfp->iseq;
        int line_no = rb_vm_get_sourceline(cfp);
        VALUE file = iseq->filename,
              name = iseq->name;
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
      // printf("CFUNC\n");
      return Qnil;
    }
  } else {
    // level is out of bounds
  }
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
