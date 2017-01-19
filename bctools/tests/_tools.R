library(compiler)
library(bctools)

getOutput <- function(bc, verbose=0){
    capture.output(print(compiler::disassemble(bc), verbose=verbose))
}

operands <- function(out){
    out <- filterWhitespaces(out)

    #extract src and expr references
    out <- grep("(- #[0-9])|( @ )",out, value=TRUE, invert=TRUE)

    out
}

grepOp <- function(out, op){
    length( Filter(function(v){ grepl(op, v); }, out) ) > 0;
}

filterWhitespaces <- function(v){
    #extract empty lines
    v <- Filter(function(l){nchar(l) > 0}, v)

    #extract whitespaces
    lapply(v, function(v) gsub("(^\\s)|(\\s$)","",gsub("\\s+", " ", v)) )
}

eqOut <- function(c1, c2){
    identical(c1,c2)
}

MAXVERBOSITY=2;
truefromlvl <- function(f, fromlvl){
    for(i in 0:MAXVERBOSITY){
        ## containing when i >= fromlvl
        if( !(f(i) ^ ( i >= fromlvl ) ) )
            return(0);
    }
    TRUE
}