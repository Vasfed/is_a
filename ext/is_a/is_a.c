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

void Init_is_a(){
  rb_mIsA = rb_define_module("IsA");
  rb_define_singleton_method(rb_mIsA, "class_of", rb_get_class_of, 1);
  rb_define_singleton_method(rb_mIsA, "id_of", rb_object_id_of, 1);
}
