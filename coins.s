      .data
q:    .string "QUARTER"
n:    .string "NICKEL"
d:    .string "DIME"
p:    .string "PENNY"
f:    .string "%s, "
fai:  .string "FAILURE"
el:   .string "\n"

pts:  .quad q,  d,  n, p, 0
vls:  .int 25, 10, 5, 1, 0
      .text
      .global coins

coins:
# rbx: idx
# r11: pts pointer
# r12: vls pointer

  pushq %rbx
  pushq %r12
  pushq %r13

  cmpq $0, %rdi
  je done

  movq %rdi, %r13
  xorq %rbx, %rbx

st:
  movslq vls(, %rbx, 4), %r12

  cmpq $0, %r12
  jz fail

  cmpq %r13, %r12
  jle l

  incq %rbx
  jmp st
l:
  xorq %rax, %rax
  movq pts(, %rbx, 8), %rsi
  movq $f, %rdi
  callq printf

  movq %r13, %rdi
  subq %r12, %rdi
  callq coins
  jmp done

fail:
  movq f, %rdi
  movq fai, %rsi
  call printf

done:
  popq %r13
  popq %r12
  popq %rbx
  retq
