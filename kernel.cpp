// kernel.cpp - Main kernel entry point
volatile char* video = (volatile char*)0xB8000;
void printf(const char* str) {
    // Write each character to video memory
    for (int i = 0; str[i] != '\0'; i++) 
    {
        video[i * 2] = str[i];      // Character byte
        video[i * 2 + 1] = 0x07;    // Attribute: light gray on black
                                    // 0x07 = foreground:7(gray), background:0(black)
    }
}

// Prevent C++ name mangling so loader.s can find kernel_main
extern "C" void kernel_main(unsigned int magic, unsigned int info)
{
    // magic: Multiboot magic (should be 0x2BADB002)
    // info: Address of multiboot info structure
    
    const char* msg = "Hello world";            // Message to display
    printf(msg);
    // VGA text mode video memory at 0xB8000
    // Layout: 80x25 chars, each char takes 2 bytes (char + color)
    // Return to loader.s which halts the CPU
}