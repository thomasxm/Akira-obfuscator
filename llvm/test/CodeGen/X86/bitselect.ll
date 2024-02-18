; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=-bmi | FileCheck %s --check-prefixes=X64,X64-NOBMI
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+bmi | FileCheck %s --check-prefixes=X64,X64-BMI

; PR46472
; bitselect(a,b,m) == or(and(a,not(m)),and(b,m))
; bitselect(a,b,m) == xor(and(xor(a,b),m),a)

define i8 @bitselect_i8(i8 %a, i8 %b, i8 %m) nounwind {
; X86-LABEL: bitselect_i8:
; X86:       # %bb.0:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xorb %cl, %al
; X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; X86-NEXT:    xorb %cl, %al
; X86-NEXT:    retl
;
; X64-LABEL: bitselect_i8:
; X64:       # %bb.0:
; X64-NEXT:    andl %edx, %esi
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:    notb %al
; X64-NEXT:    andb %dil, %al
; X64-NEXT:    orb %sil, %al
; X64-NEXT:    retq
  %not = xor i8 %m, -1
  %ma = and i8 %a, %not
  %mb = and i8 %b, %m
  %or = or i8 %ma, %mb
  ret i8 %or
}

define i16 @bitselect_i16(i16 %a, i16 %b, i16 %m) nounwind {
; X86-LABEL: bitselect_i16:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    xorw %ax, %cx
; X86-NEXT:    andw {{[0-9]+}}(%esp), %cx
; X86-NEXT:    xorl %ecx, %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-NOBMI-LABEL: bitselect_i16:
; X64-NOBMI:       # %bb.0:
; X64-NOBMI-NEXT:    movl %edx, %eax
; X64-NOBMI-NEXT:    andl %edx, %esi
; X64-NOBMI-NEXT:    notl %eax
; X64-NOBMI-NEXT:    andl %edi, %eax
; X64-NOBMI-NEXT:    orl %esi, %eax
; X64-NOBMI-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NOBMI-NEXT:    retq
;
; X64-BMI-LABEL: bitselect_i16:
; X64-BMI:       # %bb.0:
; X64-BMI-NEXT:    andnl %edi, %edx, %eax
; X64-BMI-NEXT:    andl %edx, %esi
; X64-BMI-NEXT:    orl %esi, %eax
; X64-BMI-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-BMI-NEXT:    retq
  %not = xor i16 %m, -1
  %ma = and i16 %a, %not
  %mb = and i16 %b, %m
  %or = or i16 %ma, %mb
  ret i16 %or
}

define i32 @bitselect_i32(i32 %a, i32 %b, i32 %m) nounwind {
; X86-LABEL: bitselect_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xorl %ecx, %eax
; X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xorl %ecx, %eax
; X86-NEXT:    retl
;
; X64-NOBMI-LABEL: bitselect_i32:
; X64-NOBMI:       # %bb.0:
; X64-NOBMI-NEXT:    movl %esi, %eax
; X64-NOBMI-NEXT:    xorl %edi, %eax
; X64-NOBMI-NEXT:    andl %edx, %eax
; X64-NOBMI-NEXT:    xorl %edi, %eax
; X64-NOBMI-NEXT:    retq
;
; X64-BMI-LABEL: bitselect_i32:
; X64-BMI:       # %bb.0:
; X64-BMI-NEXT:    andnl %edi, %edx, %eax
; X64-BMI-NEXT:    andl %edx, %esi
; X64-BMI-NEXT:    orl %esi, %eax
; X64-BMI-NEXT:    retq
  %not = xor i32 %m, -1
  %ma = and i32 %a, %not
  %mb = and i32 %b, %m
  %or = or i32 %ma, %mb
  ret i32 %or
}

define i64 @bitselect_i64(i64 %a, i64 %b, i64 %m) nounwind {
; X86-LABEL: bitselect_i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xorl %ecx, %eax
; X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xorl %ecx, %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %esi, %edx
; X86-NEXT:    andl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %esi, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-NOBMI-LABEL: bitselect_i64:
; X64-NOBMI:       # %bb.0:
; X64-NOBMI-NEXT:    movq %rsi, %rax
; X64-NOBMI-NEXT:    xorq %rdi, %rax
; X64-NOBMI-NEXT:    andq %rdx, %rax
; X64-NOBMI-NEXT:    xorq %rdi, %rax
; X64-NOBMI-NEXT:    retq
;
; X64-BMI-LABEL: bitselect_i64:
; X64-BMI:       # %bb.0:
; X64-BMI-NEXT:    andnq %rdi, %rdx, %rax
; X64-BMI-NEXT:    andq %rdx, %rsi
; X64-BMI-NEXT:    orq %rsi, %rax
; X64-BMI-NEXT:    retq
  %not = xor i64 %m, -1
  %ma = and i64 %a, %not
  %mb = and i64 %b, %m
  %or = or i64 %ma, %mb
  ret i64 %or
}

define i128 @bitselect_i128(i128 %a, i128 %b, i128 %m) nounwind {
; X86-LABEL: bitselect_i128:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    xorl %edi, %ecx
; X86-NEXT:    andl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    xorl %edi, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    xorl %ebx, %edi
; X86-NEXT:    andl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    xorl %ebx, %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    xorl %esi, %ebx
; X86-NEXT:    andl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    xorl %esi, %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    xorl %edx, %esi
; X86-NEXT:    andl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    xorl %edx, %esi
; X86-NEXT:    movl %esi, 12(%eax)
; X86-NEXT:    movl %ebx, 8(%eax)
; X86-NEXT:    movl %edi, 4(%eax)
; X86-NEXT:    movl %ecx, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    retl $4
;
; X64-NOBMI-LABEL: bitselect_i128:
; X64-NOBMI:       # %bb.0:
; X64-NOBMI-NEXT:    movq %rdx, %rax
; X64-NOBMI-NEXT:    xorq %rdi, %rax
; X64-NOBMI-NEXT:    andq %r8, %rax
; X64-NOBMI-NEXT:    xorq %rdi, %rax
; X64-NOBMI-NEXT:    xorq %rsi, %rcx
; X64-NOBMI-NEXT:    andq %r9, %rcx
; X64-NOBMI-NEXT:    xorq %rsi, %rcx
; X64-NOBMI-NEXT:    movq %rcx, %rdx
; X64-NOBMI-NEXT:    retq
;
; X64-BMI-LABEL: bitselect_i128:
; X64-BMI:       # %bb.0:
; X64-BMI-NEXT:    andnq %rsi, %r9, %rsi
; X64-BMI-NEXT:    andnq %rdi, %r8, %rax
; X64-BMI-NEXT:    andq %r9, %rcx
; X64-BMI-NEXT:    orq %rcx, %rsi
; X64-BMI-NEXT:    andq %r8, %rdx
; X64-BMI-NEXT:    orq %rdx, %rax
; X64-BMI-NEXT:    movq %rsi, %rdx
; X64-BMI-NEXT:    retq
  %not = xor i128 %m, -1
  %ma = and i128 %a, %not
  %mb = and i128 %b, %m
  %or = or i128 %ma, %mb
  ret i128 %or
}

;
; Bitselect between constants
;

; bitselect(52, -6553, m)
; TODO: Non-BMI canonicalization is actually better.
define i32 @bitselect_constants_i32(i32 %m) nounwind {
; X86-LABEL: bitselect_constants_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl $-6573, %eax # imm = 0xE653
; X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xorl $52, %eax
; X86-NEXT:    retl
;
; X64-NOBMI-LABEL: bitselect_constants_i32:
; X64-NOBMI:       # %bb.0:
; X64-NOBMI-NEXT:    movl %edi, %eax
; X64-NOBMI-NEXT:    andl $-6573, %eax # imm = 0xE653
; X64-NOBMI-NEXT:    xorl $52, %eax
; X64-NOBMI-NEXT:    retq
;
; X64-BMI-LABEL: bitselect_constants_i32:
; X64-BMI:       # %bb.0:
; X64-BMI-NEXT:    movl %edi, %eax
; X64-BMI-NEXT:    notl %eax
; X64-BMI-NEXT:    andl $52, %eax
; X64-BMI-NEXT:    andl $-6553, %edi # imm = 0xE667
; X64-BMI-NEXT:    orl %edi, %eax
; X64-BMI-NEXT:    retq
  %not = xor i32 %m, -1
  %ma = and i32 52, %not
  %mb = and i32 -6553, %m
  %or = or i32 %ma, %mb
  ret i32 %or
}