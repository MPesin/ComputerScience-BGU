#include <stdio.h>

extern void calc_div(int x, int k);

int check (int x, int k){
    if (x<0)
        return 0;
    if (k<=0 || k>31)
        return 0;
    return 1;
}

int main(int argc, char** argv)
{
    int x;
    int k;
    scanf("%d", &x);
    scanf("%d", &k);
    calc_div(x,k);    
    return 0;
}
