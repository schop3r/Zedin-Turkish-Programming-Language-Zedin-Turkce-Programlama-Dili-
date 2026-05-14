// arm_backend.cpp - Zedin ARM64 Assembly Backend v0.2
#pragma once
#include "Bytecode.h"
#include <sstream>
#include <string>
#include <map>
using namespace std;

class ARMBackend {
    shared_ptr<BChunk> chunk;
    stringstream cikti;
    map<string, int> degiskenler;
    int fp_offset = 0;

    void yaz(string s) { cikti << "    " << s << "\n"; }
    void etiket(string s) { cikti << s << ":\n"; }
    void yorum(string s) { cikti << "    // " << s << "\n"; }

public:
    ARMBackend(shared_ptr<BChunk> c) : chunk(c) {}

    string uret() {
        cikti << ".section .data\n.align 3\n";
        cikti << "_fmt_int: .asciz \"%lld\\n\"\n";
        cikti << "_fmt_str: .asciz \"%s\\n\"\n";
        for (size_t i = 0; i < chunk->sabitler.size(); i++)
            if (chunk->sabitler[i].type == BVal::STR)
                cikti << "_s" << i << ": .asciz \"" << chunk->sabitler[i].str << "\"\n";
        cikti << "\n.section .text\n.global main\n.align 2\n\n";
        int yerel = hesapla_yerel();
        etiket("main");
        yaz("stp x29, x30, [sp, #-16]!");
        yaz("mov x29, sp");
        if (yerel > 0) yaz("sub sp, sp, #" + to_string(yerel));
        uret_bytecode();
        yaz("mov x0, #0");
        if (yerel > 0) yaz("add sp, sp, #" + to_string(yerel));
        yaz("ldp x29, x30, [sp], #16");
        yaz("ret");
        return cikti.str();
    }

private:
    int hesapla_yerel() {
        int n = 0;
        for (auto b : chunk->code)
            if (b == (uint8_t)OpCode::OP_TANI || b == (uint8_t)OpCode::OP_TANI_GLOBAL) n++;
        return ((n * 16 + 15) / 16) * 16;
    }

    void uret_bytecode() {
        size_t i = 0;
        while (i < chunk->code.size()) {
            cikti << "_L" << i << ":\n";
            OpCode op = (OpCode)chunk->code[i++];
            switch (op) {
            case OpCode::OP_SAYI: { int idx=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; long long v=(long long)chunk->sabitler[idx].num; yorum("SAYI "+to_string(v)); yaz("mov x0, #"+to_string(v)); yaz("str x0, [sp, #-16]!"); yaz("mov x9, #0"); break; }
            case OpCode::OP_METIN: { int idx=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; yorum("METIN"); yaz("adr x0, _s"+to_string(idx)); yaz("str x0, [sp, #-16]!"); yaz("mov x9, #1"); break; }
            case OpCode::OP_TUZ: yorum("TUZ"); yaz("mov x0, #1"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_TERS: case OpCode::OP_BOS: yorum("TERS/BOS"); yaz("mov x0, #0"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_TOPLA: yorum("TOPLA"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("add x0, x0, x1"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_CIKAR: yorum("CIKAR"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("sub x0, x0, x1"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_CARP: yorum("CARP"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("mul x0, x0, x1"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_BOL: yorum("BOL"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("sdiv x0, x0, x1"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_NEG: yorum("NEG"); yaz("ldr x0, [sp], #16"); yaz("neg x0, x0"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_ESIT: yorum("ESIT"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("cmp x0, x1"); yaz("cset x0, eq"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_ESIT_DEGIL: yorum("ESIT_DEGIL"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("cmp x0, x1"); yaz("cset x0, ne"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_BUYUK: yorum("BUYUK"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("cmp x0, x1"); yaz("cset x0, gt"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_KUCUK: yorum("KUCUK"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("cmp x0, x1"); yaz("cset x0, lt"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_BUYUK_ESIT: yorum("BUYUK_ESIT"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("cmp x0, x1"); yaz("cset x0, ge"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_KUCUK_ESIT: yorum("KUCUK_ESIT"); yaz("ldr x1, [sp], #16"); yaz("ldr x0, [sp], #16"); yaz("cmp x0, x1"); yaz("cset x0, le"); yaz("str x0, [sp, #-16]!"); break;
            case OpCode::OP_TANI: case OpCode::OP_TANI_GLOBAL: { int idx=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; string isim=chunk->sabitler[idx].str; fp_offset+=16; degiskenler[isim]=fp_offset; yorum("TANI "+isim); yaz("ldr x0, [sp], #16"); yaz("str x0, [x29, #-"+to_string(fp_offset)+"]"); break; }
            case OpCode::OP_YUKLE: case OpCode::OP_YUKLE_GLOBAL: { int idx=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; string isim=chunk->sabitler[idx].str; yorum("YUKLE "+isim); if(degiskenler.count(isim)) yaz("ldr x0, [x29, #-"+to_string(degiskenler[isim])+"]"); else yaz("mov x0, #0"); yaz("str x0, [sp, #-16]!"); break; }
            case OpCode::OP_SAKLA: case OpCode::OP_SAKLA_GLOBAL: { int idx=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; string isim=chunk->sabitler[idx].str; yorum("SAKLA "+isim); yaz("ldr x0, [sp], #16"); if(degiskenler.count(isim)) yaz("str x0, [x29, #-"+to_string(degiskenler[isim])+"]"); yaz("str x0, [sp, #-16]!"); break; }
            case OpCode::OP_YAZ: { int argc=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; yorum("YAZ"); yaz("ldr x1, [sp], #16"); yaz("cmp x9, #1"); yaz("b.eq _yaz_str_"+to_string(i)); yaz("adr x0, _fmt_int"); yaz("bl printf"); yaz("b _yaz_son_"+to_string(i)); etiket("_yaz_str_"+to_string(i)); yaz("adr x0, _fmt_str"); yaz("bl printf"); etiket("_yaz_son_"+to_string(i)); break; }
            case OpCode::OP_POP: yorum("POP"); yaz("add sp, sp, #16"); break;
            case OpCode::OP_ATLA: { int16_t off=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; yorum("ATLA"); yaz("b _L"+to_string((int)i+off)); break; }
            case OpCode::OP_ATLA_YANLIS: { int16_t off=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; yorum("ATLA_YANLIS"); yaz("ldr x0, [sp], #16"); yaz("cbz x0, _L"+to_string((int)i+off)); break; }
            case OpCode::OP_ATLA_DOGRU: { int16_t off=chunk->code[i]|(chunk->code[i+1]<<8);i+=2; yorum("ATLA_DOGRU"); yaz("ldr x0, [sp], #16"); yaz("cbnz x0, _L"+to_string((int)i+off)); break; }
            case OpCode::OP_HALT: yorum("HALT"); break;
            case OpCode::OP_DON: yorum("DON"); yaz("ldr x0, [sp], #16"); yaz("ldp x29, x30, [sp], #16"); yaz("ret"); break;
            case OpCode::OP_DON_BOS: yorum("DON_BOS"); yaz("mov x0, #0"); yaz("ldp x29, x30, [sp], #16"); yaz("ret"); break;
            default: {
                // Argumanlı opcode'lar 2 byte arg alır
                int opn = (int)op;
                yorum("TODO opcode "+to_string(opn));
                // Argumanlı olanlar: SAYI,METIN,YUKLE,SAKLA,TANI,YUKLE_GLOBAL,SAKLA_GLOBAL,TANI_GLOBAL,YAZ,ATLA,ATLA_YANLIS,ATLA_DOGRU,CAGIR,LISTE
                if(opn==0||opn==1||opn==5||opn==6||opn==7||opn==23||opn==26||opn==27||opn==28||opn==29||opn==34||opn==35||opn==36||opn==37) {
                    if(i+1 < chunk->code.size()) i+=2;
                }
                break;
            }
            }
        }
    }
};

string zedin_arm_uret(shared_ptr<BChunk> chunk) {
    ARMBackend b(chunk); return b.uret();
}
