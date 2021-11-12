.syntax unified

.global ResetHandler
.section .text.ResetHandler
	.align 4
	.func ResetHandler
	.type ResetHandler, %function
ResetHandler:
	ldr sp, =_estack
	bl __initialize_platform
	bl __prepare_environment
	bl __libc_init_array
	b __start
	.endfunc
	.size ResetHandler, .-ResetHandler
