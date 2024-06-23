#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

#if 1
static int hello_init(void)
{

	printk("hello init\n");
	return 0;
}

static void hello_exit(void)
{

	printk("hello exit\n");
}

module_init(hello_init);
module_exit(hello_exit);
#else
int init_module(void)
{

	printk("hello init\n");
	return 0;
}

void cleanup_module(void)
{
	printk("hello exit\n");
}

#endif

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("hello test");

/* https://www.cnblogs.com/schips/p/linux_kernel_initcall_and_module_init.html 
 * https://www.cnblogs.com/kfggww/p/17598809.html
 * https://linux-kernel-labs.github.io/refs/heads/master/labs/kernel_modules.html
 * https://tldp.org/LDP/lkmpg/2.6/html/index.html
 *
 * moudle_init机制：
 * #ifndef MOUDLE
 * #define module_init(x)  __initcall(x);
 * #define module_exit(x)  __exitcall(x);
 * #else
 * #define module_init(initfn) \
 * static inline initcall_t __maybe_unused __inittest(void)
 * { return initfn; } \
 *  int init_module(void) __copy(initfn) __attribute__((alias(#initfn)));
 * #define module_exit(exitfn)
 * static inline exitcall_t __maybe_unused __exittest(void) \
 * { return exitfn; } \
 * void cleanup_module(void) __copy(exitfn) __attribute__((alias(#exitfn))); 
 * #endif
 * 在函数编译时obj-m obj-y 分别对应把module_init修饰的函数编译成module和编译进内核
 * a.编译进内核的，会在linux启动中通过do_initcalls()调用
 * b.被配置成module在插入(insmode;depmode,modprobe)操作时调用
 * 
*/
