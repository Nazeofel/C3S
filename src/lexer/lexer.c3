module lexer;
import std::io;
import std::collections::list;
import std::core::dstring;


enum Tokens :  int (char c) { 
    OBRACKET = '{',
    CBRACKET = '}',
    OPAREN = '(',
    CPAREN = ')',
    SEMI_COLON = ':',
    PERCENTAGE = '%',

}


struct TokenData { 
    DString tokenType;
    DString token;
    ulong start;
    ulong end;
}


fn void lexer(String css){
    DString buffer = dstring::new();
    List(<TokenData>) tokens;
    defer tokens.free();

    for(usz i = 0; i < css.len; ++i){
        char c = css[i];
        usz idx = i;
        if(c == ' ' || c == '\n' || c == '\r' ||  c == ':' || c == ';' || buffer.str_view() == "\uFEFF"  || buffer.str_view() == "\x0D" || buffer.str_view() == "0x20"){
            String strc = buffer.copy_str();
            tokens.push( TokenData {
                .tokenType  = dstring::new("IDENTIFIER"),
                .token = dstring::new(strc),
                .start = idx - strc.len,
                .end   = idx
            });
            buffer.free();
            continue;
        }

        buffer.append_char(c);

        foreach (function : lexer::Functions.values){
            if(buffer.str_view() == function.s){
                String strc = buffer.copy_str();
                tokens.push(TokenData {
                .tokenType  = dstring::new("FUNCTION"),
                .token = dstring::new(strc),
                .start = idx - strc.len,
                .end   = idx
            });
                buffer.free();
            }
        }
        
        foreach (keyword : lexer::Keywords.values){
            if(buffer.str_view() == keyword.s){
                String strc = buffer.copy_str();
                tokens.push(TokenData {
                .tokenType  = dstring::new("KEYWORD"),
                .token = dstring::new(strc),
                .start = idx - strc.len,
                .end   = idx
            });
                buffer.free();
            }
        }

        foreach (property : lexer::CSSProperties.values){
            if(buffer.str_view() == property.s){
                String strc = buffer.copy_str();
                tokens.push(TokenData {
                .tokenType  = dstring::new("PROPERTY"),
                .token = dstring::new(strc),
                .start = idx - strc.len,
                .end   = idx
            });
                buffer.free();
            }
        }

        switch(c){
            case Tokens.OBRACKET.c:
            case Tokens.CBRACKET.c:
                String strc = buffer.copy_str();
                tokens.push(TokenData {
                .tokenType  = dstring::new("X"),
                .token = dstring::new(strc),
                .start = idx - strc.len,
                .end   = idx
            });
                buffer.free();
                break;
            default:    // warning: default label in switch which covers all enumeration value
                break;
        }
    }

    foreach (element : tokens){
        foreach (char c : element.token.str_view()){
            io::printf("0x%x start: %d - end: %d", c, element.start, element.end);
        }

         

        //io::printf("0x%x start: %d - end: %d", element.token, element.start, element.end); prints every string and there is the space
        
        element.tokenType.free();
        element.token.free();
    }
}

/*
        io::printfn("%d start: %d - end: %d", element.token, element.start, element.end);

*/