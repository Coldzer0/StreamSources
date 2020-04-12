program Mal;

uses
  windows,jwaws2tcpip,jwaWinSock2;

const
  DEFAULT_PORT = '27015';

var
  ret : integer;
  SocketData : TwsaData;
  hints : TAddrInfo;
  Result,ptr : PAddrInfo;
  ConnectSocket : TSocket;
  iResult : Integer;
begin
  Initialize(SocketData);
  ret := WSAStartup(WINSOCK_VERSION,SocketData);
  if ret <> 0 then
  begin
    WriteLn('WSAStartup failed: ', ret);
    ExitProcess(1);
  end
  else
    WriteLn('WSAStartup Ok');

  Initialize(hints);

  hints.ai_family   := AF_UNSPEC;
  hints.ai_socktype := SOCK_STREAM;
  hints.ai_protocol := IPPROTO_TCP;

  Result := nil;

  iResult := getaddrinfo(argv[1],DEFAULT_PORT,@hints, Result);
  if iResult <> 0 then
  begin
    WriteLn('getaddrinfo failed : ', iResult);
    WSACleanup;
    ExitProcess(1);
  end;
  if Result = nil then
  begin
    WriteLn('MemAlloc Error');
    Exit;
  end;

  ptr := Result;
  ConnectSocket := INVALID_SOCKET;

  ConnectSocket := socket(ptr^.ai_family,ptr^.ai_socktype,ptr^.ai_protocol);
  if ConnectSocket = INVALID_SOCKET then
  begin
    WriteLn('Error at socket(): ',WSAGetLastError);
    freeaddrinfo(Result);
    WSACleanup;
    ExitProcess(1);
  end;

  iResult := connect(ConnectSocket,ptr^.ai_addr,Integer(ptr^.ai_addrlen));
  if iResult = SOCKET_ERROR then
  begin
    closesocket(ConnectSocket);
    ConnectSocket := INVALID_SOCKET;
  end;
  freeaddrinfo(result);

  if ConnectSocket = INVALID_SOCKET then
  begin
    WriteLn('Unable to connect to server!');
    WSACleanup;
    ExitProcess(1);
  end;


  WriteLn(#13#10#13#10#13#10);
end.

