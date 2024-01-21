int main(void)
{
    int a = 1;
    int b = 2;
    int c, d;

    c = a + b;

    while (1)
    {
        d = c + 1;
    }
};

// void __attribute__((section (".text.boot"))) _start() {
//     main();
// };