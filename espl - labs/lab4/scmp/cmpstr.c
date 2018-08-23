
int cmpstr(char *char1, char *char2){
  while (*char1 != 0 && *char2 != 0){
    if (*char1>*char2)
      return 1;
    else if (*char1<*char2)
      return 2;
    char1++; char2++;
  }
  
  int ans = -1;
  if (*char1 == 0){ 
    if (*char2 == 0){
      ans = 0;
    } else 
      ans = 2;
  } else
    ans = 1;
  
  return ans;
}
