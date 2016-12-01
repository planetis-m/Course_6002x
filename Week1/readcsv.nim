type
  Item = ptr array[0..3, char]

var ni: array[0..99, string] =
  ["PVZW","OGVB","FYGN","NRWG","MDKW","FSGE","ROGE","FSOM","WUTK","RTKU",
  "NUMS","QREN","VCRU","OPDE","PRTN","TAQN","HFUE","LTEC","RTCU","LMQD",
  "DYHJ","NFEJ","BPJG","YTCB","OSYN","WOUT","VLNE","UIOJ","BETI","JORA",
  "YOEK","LXFU","UJYW","IYZE","SCUE","QVCL","GVIU","JXOZ","JLKF","DPJW",
  "DJSL","THQN","OUST","GPBC","FYLJ","QHYV","TVMA","FYDJ","USDP","QLGX",
  "PNQB","LXSE","JYKE","CNLJ","FCLE","SBMD","UTWI","DKVW","LESI","ANVQ",
  "AIYU","VXBQ","TGNK","UZYC","SWIY","YJGS","FYEG","FTZW","GLFC","CSLD",
  "RUOB","TJQE","YUFA","EITH","RPYW","PRBM","WKEL","MHCR","FOTG","AXZI",
  "WMOQ","DQXI","YLOE","ZFPA","SXNK","OTRM","TVIP","BHZI","MBTJ","DMCJ",
  "XDRT","MTGQ","RKHQ","FTPB","XNAK","MUNH","UDZF","CQOF","UPVL","EGFZ"]

proc ffi(s: var string): Item =
  cast[Item](addr s[0])

proc ffi[T](a: var array[T, string]): array[T, Item] =
  for i in 0..len(a)-1:
    result[i] = ffi(a[i])

var n = ffi(ni)

var f = open("data", fmWrite)

let length = len(n) * sizeof(n[0])
if f.writeBuffer(addr n[0], length) != length:
  echo "Error: Could not write binary file"

close(f)
