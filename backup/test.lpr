program test;

uses
  windows,jwaws2tcpip,jwaWinSock2;

const
  DEFAULT_PORT = '27015';

var
  ret : integer;
  SocketData : TwsaData;
  hints,ptr : TAddrInfo;
  res : PAddrInfo;

  iResult : Integer;
begin
  Initialize(SocketData);
  ret := WSAStartup(WINSOCK_VERSION,SocketData);
  if ret <> 0 then
  begin
    WriteLn('WSAStartup failed: ', ret);
    ExitProcess(1);
  end;

  Initialize(hints);

  hints.ai_family   := AF_UNSPEC;
  hints.ai_socktype := SOCK_STREAM;
  hints.ai_protocol := IPPROTO_TCP;

  WriteLn('Size : ', SizeOf(TAddrInfo));

  //res := AllocMem(SizeOf(TAddrInfo));
  //if res = nil then
  //begin
  //  WriteLn('MemAlloc Error');
  //  Exit;
  //end;

  iResult := getaddrinfo(argv[1],DEFAULT_PORT,@hints, res);
  if iResult <> 0 then
  begin
    WriteLn('getaddrinfo failed : ', iResult);
    WSACleanup;
    ExitProcess(1);
  end;
  WriteLn(res^.ai_protocol);
  //Freememory(res);

  WriteLn('WSAStartup Ok');
end.

