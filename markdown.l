%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "node.h"
    #include "y.tab.h"

%}

newLine (\n)+
h1 #" "
h2 ##" "
h3 ###" "
unorderedList -" "
italic "\*"([a-zA-Z0-9])+"\*"
bold "\*\*"([a-zA-Z0-9])+"\*\*"
underline "\+\+"([a-zA-Z0-9])+"\+\+"
text ([0-9A-Za-z一-龥_,\-\.:/\(\)])+

%%

{newLine}    { return NEWLINE;}

{h1} {  return H1; }
{h2} {  return H2; }
{h3} {  return H3; }

{unorderedList} { return UNORDEREDLIST; }

{italic} {
    char *str = malloc(strlen(yytext));
    strncpy(str, &yytext[1], strlen(yytext) - 2);
    yylval.p_node.text = strdup(str);
    free(str);
    return ITALIC;
}

{bold} {
    char *str = malloc(strlen(yytext));
    strncpy(str, &yytext[2], strlen(yytext) - 4);
    yylval.p_node.text = strdup(str);
    free(str);
    return BOLD;
}
{underline} {
    char *str = malloc(strlen(yytext));
    strncpy(str, &yytext[2], strlen(yytext) - 4);
    yylval.p_node.text = strdup(str);
    free(str);
    return UNDERLINE;
}

{text} { yylval.p_node.text = strdup(yytext);return TEXT;}

%%