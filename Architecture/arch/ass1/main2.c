#include <stdio.h>
#include <stdlib.h>

extern void calc_func(long long *x, int numOfRounds);

int compare (long long * x, long long * y)
{
	int ans = 0;
	if ((*x) == (*y))
	{
		ans = 1;
	}

	return ans;
}

int main(int argc, char** argv)
{	
	long long x;
	int num_of_rounds;

	scanf("%llX", &x);
	
	scanf("%i", &num_of_rounds);

	calc_func(&x, num_of_rounds);

	return 0;
}
