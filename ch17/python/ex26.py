import sys,platform,os;
os_sys = platform.system();  # Windows vs Linux
if os_sys == "Windows":
  os.system("color");# Enable ANSI in Windows
esc = "\033";
ansi = {'esc':esc,'cls':esc+"[2J",'reset':esc+"[0m",
        'fg_blk':esc+"[30m",'fg_red':esc+"[31m",'fg_grn':esc+"[32m",
        'fg_ylw':esc+"[33m",'fg_blu':esc+"[34m",'fg_mgt':esc+"[35m",
        'fg_cya':esc+"[36m",'fg_wht':esc+"[37m",'fg_dft':esc+"[39m",
        'bg_blk':esc+"[40m",'bg_red':esc+"[41m",'bg_grn':esc+"[42m",
        'bg_ylw':esc+"[43m",'bg_blu':esc+"[44m",'bg_mgt':esc+"[45m",
        'bg_cya':esc+"[46m",'bg_wht':esc+"[47m",'bg_dft':esc+"[49m",
        'bold':esc+"[1m",'dim':esc+"[2m",'italic':esc+"[3m",
        'underline':esc+"[4m",'inverse':esc+"[7m",'strike':esc+"[9m",
       };
print(ansi['fg_red']+"Hello"+ansi['reset']);
