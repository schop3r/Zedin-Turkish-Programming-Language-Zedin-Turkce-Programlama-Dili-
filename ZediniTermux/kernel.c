void outb(unsigned short port, unsigned char data) {
    asm volatile("outb %0, %1" : : "a"(data), "Nd"(port));
}

unsigned char inb(unsigned short port) {
    unsigned char result;
    asm volatile("inb %1, %0" : "=a"(result) : "Nd"(port));
    return result;
}

void k_print(char* message, int line) {
    char* vidptr = (char*)0xb8000 + (line * 160);
    int i = 0;
    while (message[i] != 0) {
        vidptr[i*2] = message[i];
        vidptr[i*2+1] = 0x07;
        i++;
    }
}

void main() {
    k_print("ZEDINI OS: GUVENLI MODDA CALISIYOR...", 0);
    k_print("Klavyeye basinca scancode goreceksin:", 1);

    while(1) {
        // Klavyeden veri gelip gelmediğini kontrol et (Status Register)
        if (inb(0x64) & 0x01) {
            unsigned char scancode = inb(0x60);
            if (scancode < 0x80) { // Sadece tuşa basılma olayları
                k_print("TUSA BASILDI! SCANCODE ALINDI.   ", 3);
            }
        }
    }
}

