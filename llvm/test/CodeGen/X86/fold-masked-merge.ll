; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -o - %s -mtriple=x86_64-- | FileCheck %s --check-prefixes=CHECK,NOBMI
; RUN: llc -o - %s -mtriple=x86_64-- -mattr=+bmi | FileCheck %s --check-prefixes=CHECK,BMI
;
; test that masked-merge code is generated as "xor;and;xor" sequence or
; "andn ; and; or" if and-not is available.

define i32 @masked_merge0(i32 %a0, i32 %a1, i32 %a2) {
; NOBMI-LABEL: masked_merge0:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %esi, %eax
; NOBMI-NEXT:    xorl %edx, %eax
; NOBMI-NEXT:    andl %edi, %eax
; NOBMI-NEXT:    xorl %edx, %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: masked_merge0:
; BMI:       # %bb.0:
; BMI-NEXT:    andl %edi, %esi
; BMI-NEXT:    andnl %edx, %edi, %eax
; BMI-NEXT:    orl %esi, %eax
; BMI-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not = xor i32 %a0, -1
  %and1 = and i32 %not, %a2
  %or = or i32 %and0, %and1
  ret i32 %or
}

define i16 @masked_merge1(i16 %a0, i16 %a1, i16 %a2) {
; NOBMI-LABEL: masked_merge1:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %edi, %eax
; NOBMI-NEXT:    andl %edi, %esi
; NOBMI-NEXT:    notl %eax
; NOBMI-NEXT:    andl %edx, %eax
; NOBMI-NEXT:    orl %esi, %eax
; NOBMI-NEXT:    # kill: def $ax killed $ax killed $eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: masked_merge1:
; BMI:       # %bb.0:
; BMI-NEXT:    andl %edi, %esi
; BMI-NEXT:    andnl %edx, %edi, %eax
; BMI-NEXT:    orl %esi, %eax
; BMI-NEXT:    # kill: def $ax killed $ax killed $eax
; BMI-NEXT:    retq
  %and0 = and i16 %a0, %a1
  %not = xor i16 %a0, -1
  %and1 = and i16 %a2, %not
  %or = or i16 %and0, %and1
  ret i16 %or
}

define i8 @masked_merge2(i8 %a0, i8 %a1, i8 %a2) {
; NOBMI-LABEL: masked_merge2:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %esi, %eax
; NOBMI-NEXT:    xorb %sil, %al
; NOBMI-NEXT:    andb %dil, %al
; NOBMI-NEXT:    xorb %sil, %al
; NOBMI-NEXT:    retq
;
; BMI-LABEL: masked_merge2:
; BMI:       # %bb.0:
; BMI-NEXT:    movl %edi, %eax
; BMI-NEXT:    notb %al
; BMI-NEXT:    andb %sil, %al
; BMI-NEXT:    andb %dil, %sil
; BMI-NEXT:    orb %sil, %al
; BMI-NEXT:    retq
  %not = xor i8 %a0, -1
  %and0 = and i8 %not, %a1
  %and1 = and i8 %a1, %a0
  %or = or i8 %and0, %and1
  ret i8 %or
}

define i64 @masked_merge3(i64 %a0, i64 %a1, i64 %a2) {
; NOBMI-LABEL: masked_merge3:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movq %rsi, %rax
; NOBMI-NEXT:    notq %rdx
; NOBMI-NEXT:    xorq %rdx, %rax
; NOBMI-NEXT:    notq %rax
; NOBMI-NEXT:    andq %rdi, %rax
; NOBMI-NEXT:    xorq %rdx, %rax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: masked_merge3:
; BMI:       # %bb.0:
; BMI-NEXT:    notq %rdx
; BMI-NEXT:    andnq %rdx, %rdi, %rcx
; BMI-NEXT:    andnq %rdi, %rsi, %rax
; BMI-NEXT:    orq %rcx, %rax
; BMI-NEXT:    retq
  %v0 = xor i64 %a1, -1
  %v1 = xor i64 %a2, -1
  %not = xor i64 %a0, -1
  %and0 = and i64 %not, %v1
  %and1 = and i64 %v0, %a0
  %or = or i64 %and0, %and1
  ret i64 %or
}

; not a masked merge: there is no `not` operation.
define i32 @not_a_masked_merge0(i32 %a0, i32 %a1, i32 %a2) {
; CHECK-LABEL: not_a_masked_merge0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl %edi, %esi
; CHECK-NEXT:    negl %eax
; CHECK-NEXT:    andl %edx, %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not_a_not = sub i32 0, %a0
  %and1 = and i32 %not_a_not, %a2
  %or = or i32 %and0, %and1
  ret i32 %or
}

; not a masked merge: `not` operand does not match another `and`-operand.
define i32 @not_a_masked_merge1(i32 %a0, i32 %a1, i32 %a2, i32 %a3) {
; NOBMI-LABEL: not_a_masked_merge1:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %ecx, %eax
; NOBMI-NEXT:    andl %esi, %edi
; NOBMI-NEXT:    notl %eax
; NOBMI-NEXT:    andl %edx, %eax
; NOBMI-NEXT:    orl %edi, %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: not_a_masked_merge1:
; BMI:       # %bb.0:
; BMI-NEXT:    andl %esi, %edi
; BMI-NEXT:    andnl %edx, %ecx, %eax
; BMI-NEXT:    orl %edi, %eax
; BMI-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not = xor i32 %a3, -1
  %and1 = and i32 %not, %a2
  %or = or i32 %and0, %and1
  ret i32 %or
}

; not a masked merge: one of the operands of `or` is not an `and`.
define i32 @not_a_masked_merge2(i32 %a0, i32 %a1, i32 %a2) {
; NOBMI-LABEL: not_a_masked_merge2:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %edi, %eax
; NOBMI-NEXT:    orl %edi, %esi
; NOBMI-NEXT:    notl %eax
; NOBMI-NEXT:    andl %edx, %eax
; NOBMI-NEXT:    orl %esi, %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: not_a_masked_merge2:
; BMI:       # %bb.0:
; BMI-NEXT:    orl %edi, %esi
; BMI-NEXT:    andnl %edx, %edi, %eax
; BMI-NEXT:    orl %esi, %eax
; BMI-NEXT:    retq
  %not_an_and0 = or i32 %a0, %a1
  %not = xor i32 %a0, -1
  %and1 = and i32 %not, %a2
  %or = or i32 %not_an_and0, %and1
  ret i32 %or
}

; not a masked merge: one of the operands of `or` is not an `and`.
define i32 @not_a_masked_merge3(i32 %a0, i32 %a1, i32 %a2) {
; CHECK-LABEL: not_a_masked_merge3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edx, %eax
; CHECK-NEXT:    andl %edi, %esi
; CHECK-NEXT:    xorl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not = xor i32 %a0, -1
  %not_an_and1 = xor i32 %not, %a2
  %or = or i32 %and0, %not_an_and1
  ret i32 %or
}

; not a masked merge: `not` operand must not be on same `and`.
define i32 @not_a_masked_merge4(i32 %a0, i32 %a1, i32 %a2) {
; CHECK-LABEL: not_a_masked_merge4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl %esi, %eax
; CHECK-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not = xor i32 %a2, -1
  %and1 = and i32 %not, %a2
  %or = or i32 %and0, %and1
  ret i32 %or
}

; should not transform when operands have multiple users.
define i32 @masked_merge_no_transform0(i32 %a0, i32 %a1, i32 %a2, ptr %p1) {
; NOBMI-LABEL: masked_merge_no_transform0:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %edi, %eax
; NOBMI-NEXT:    andl %edi, %esi
; NOBMI-NEXT:    notl %eax
; NOBMI-NEXT:    andl %edx, %eax
; NOBMI-NEXT:    orl %esi, %eax
; NOBMI-NEXT:    movl %esi, (%rcx)
; NOBMI-NEXT:    retq
;
; BMI-LABEL: masked_merge_no_transform0:
; BMI:       # %bb.0:
; BMI-NEXT:    andl %edi, %esi
; BMI-NEXT:    andnl %edx, %edi, %eax
; BMI-NEXT:    orl %esi, %eax
; BMI-NEXT:    movl %esi, (%rcx)
; BMI-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not = xor i32 %a0, -1
  %and1 = and i32 %not, %a2
  %or = or i32 %and0, %and1
  store i32 %and0, ptr %p1
  ret i32 %or
}

; should not transform when operands have multiple users.
define i32 @masked_merge_no_transform1(i32 %a0, i32 %a1, i32 %a2, ptr %p1) {
; NOBMI-LABEL: masked_merge_no_transform1:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %edx, %eax
; NOBMI-NEXT:    andl %edi, %esi
; NOBMI-NEXT:    notl %edi
; NOBMI-NEXT:    andl %edi, %eax
; NOBMI-NEXT:    orl %esi, %eax
; NOBMI-NEXT:    movl %edi, (%rcx)
; NOBMI-NEXT:    retq
;
; BMI-LABEL: masked_merge_no_transform1:
; BMI:       # %bb.0:
; BMI-NEXT:    andl %edi, %esi
; BMI-NEXT:    andnl %edx, %edi, %eax
; BMI-NEXT:    notl %edi
; BMI-NEXT:    orl %esi, %eax
; BMI-NEXT:    movl %edi, (%rcx)
; BMI-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not = xor i32 %a0, -1
  %and1 = and i32 %not, %a2
  %or = or i32 %and0, %and1
  store i32 %not, ptr %p1
  ret i32 %or
}

; should not transform when operands have multiple users.
define i32 @masked_merge_no_transform2(i32 %a0, i32 %a1, i32 %a2, ptr %p1) {
; NOBMI-LABEL: masked_merge_no_transform2:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    movl %esi, %eax
; NOBMI-NEXT:    andl %edi, %eax
; NOBMI-NEXT:    notl %edi
; NOBMI-NEXT:    andl %edx, %edi
; NOBMI-NEXT:    orl %edi, %eax
; NOBMI-NEXT:    movl %edi, (%rcx)
; NOBMI-NEXT:    retq
;
; BMI-LABEL: masked_merge_no_transform2:
; BMI:       # %bb.0:
; BMI-NEXT:    movl %esi, %eax
; BMI-NEXT:    andl %edi, %eax
; BMI-NEXT:    andnl %edx, %edi, %edx
; BMI-NEXT:    orl %edx, %eax
; BMI-NEXT:    movl %edx, (%rcx)
; BMI-NEXT:    retq
  %and0 = and i32 %a0, %a1
  %not = xor i32 %a0, -1
  %and1 = and i32 %not, %a2
  %or = or i32 %and0, %and1
  store i32 %and1, ptr %p1
  ret i32 %or
}