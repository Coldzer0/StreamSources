program Server;

uses
  windows,jwaws2tcpip,jwaWinSock2;

const
  DEFAULT_PORT   = '27015';
  DEFAULT_BUFLEN = 512;

var
  recvbuf: array[0..DEFAULT_BUFLEN] of byte;

  ret, recvbuflen  : integer;
  SocketData : TwsaData;
  hints : TAddrInfo;
  Result,ptr : PAddrInfo;
  ListenSocket, ClientSocket : TSocket;
  iResult, iSendResult : Integer;
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

  hints.ai_family   := AF_INET;
  hints.ai_socktype := SOCK_STREAM;
  hints.ai_protocol := IPPROTO_TCP;
  hints.ai_flags    := AI_PASSIVE;

  Result := nil;

  iResult := getaddrinfo(nil,DEFAULT_PORT,@hints, Result);
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
  ListenSocket := INVALID_SOCKET;

  ListenSocket := socket(ptr^.ai_family,ptr^.ai_socktype,ptr^.ai_protocol);
  if ListenSocket = INVALID_SOCKET then
  begin
    WriteLn('Error at socket(): ',WSAGetLastError);
    freeaddrinfo(Result);
    WSACleanup;
    ExitProcess(1);
  end;

  iResult := bind(ListenSocket, ptr^.ai_addr, Integer(ptr^.ai_addrlen));
  if iResult = SOCKET_ERROR then
  begin
    WriteLn('bind failed with error: ', WSAGetLastError);
    freeaddrinfo(result);
    closesocket(ListenSocket);
    WSACleanup;
    ExitProcess(1);
  end;

  if listen( ListenSocket, SOMAXCONN ) = SOCKET_ERROR then
  begin
    WriteLn('Listen failed with error: ', WSAGetLastError);
    closesocket(ListenSocket);
    WSACleanup;
    ExitProcess(1);
  end;

  ClientSocket := INVALID_SOCKET;

  ClientSocket := accept(ListenSocket, nil, nil);

  if ClientSocket = INVALID_SOCKET then
  begin
    WriteLn('accept failed: ', WSAGetLastError);
    closesocket(ListenSocket);
    WSACleanup;
    ExitProcess(1);
  end;

  recvbuflen := DEFAULT_BUFLEN;


  repeat
    iResult := recv(ClientSocket, recvbuf, recvbuflen, 0);



  until iResult <= 0;

  WriteLn(#13#10#13#10#13#10);
end.

