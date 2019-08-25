Program Tarik_Tunai;

uses crt;

Const 
   nMax=2997;
   MaxSGP=999;
   username='customerservice';
   password='customerservice';

Type 
   dataNasabah = record
      noRek, NIK, nama, jenisRek : string;
      saldo : longint;
      noUrut : integer;
   end;

   urutanRek = record
      a,b,c,n:integer;
   end;

   ArrNasabah = array[0..nMax] of dataNasabah;

Var
   TNasabah : ArrNasabah;
   key : char;
   numUrut : urutanRek;
 
   Procedure loginAttempt(var uname, pass : string; var check : boolean);
   Begin
      clrscr;
      writeln('Silakan login terlebih dahulu.');
      writeln('-----------------------------');
      write('     Username : '); readln(uname);
      write('     Password : '); readln(pass);
      Check:=(uname=username) and (pass=password);
   end;

   Procedure Login;
   Var
      uname, pass:string;
      check:boolean;
   Begin
      repeat
         begin
            LoginAttempt(uname, pass, check);
            if (not check) then
               begin
                  clrscr; 
                  if (uname<>username) and (pass<>password) then
                     writeln('Username dan password yang anda masukkan salah.')
                  else if (uname<>username) then
                     writeln('Username yang anda masukkan salah.')
                  else if (pass<>password) then
                     writeln('Password yang anda masukkan salah.');
                  readkey;
               end;  
         end;
      until check;
      exit;
   end;

   Procedure RegisterHead;
   begin
      writeln('-------------------------------------------------------');
      writeln('Selamat datang di menu register, silakan isi data anda.');
      writeln('-------------------------------------------------------');
      writeln;
   end;

   Function SeqSearch(T:ArrNasabah; n:integer; cari:string):integer;
   Var
      i:integer;
      found:boolean;
   Begin
      i:=1;
      found:=false;
      cari:=lowercase(cari);
      while (i<=n) and (not found) do
         begin
            if (T[i].NIK=cari) or (lowercase(T[i].noRek)=cari) or (lowercase(T[i].nama)=cari) then 
               found:=true; 
            i:=i+1;
          end;
      if found then
         SeqSearch:=(i-1)
      else
         SeqSearch:=0;
   end;
  
   Procedure Restart;
   Begin
      writeln;
      write('Tekan sembarang tombol untuk memasukkan ulang...');
      readkey;
      clrscr;
   end;

   Procedure inputNIK(Var T:ArrNasabah; var num:urutanRek);
   Var
      i, idx :integer;
      angka, notAvailable : boolean;
   Begin
      clrscr;
      num.n := num.n+1;
      repeat
         begin
            i:=1;
            angka:=false;
            notAvailable:=false;
            RegisterHead;
            write('NIK : '); readln(T[num.n].NIK);
            repeat
               begin
                  angka:=((T[num.n].NIK[i]) in ['0'..'9']);
                  i:=i+1;
               end;
            until (not angka) or (i>length(T[num.n].NIK));
            i:=1;
            if ((length(T[num.n].NIK))<>16) or (not angka) then
               begin
                  writeln('NIK harus berupa 16 digit angka.');
                  restart;
               end
            else
               begin
                  idx := SeqSearch(T,num.n,T[num.n].NIK);
                  notAvailable:=(idx <> 0) and (idx <> num.n);
                  if (notAvailable) then
                     begin
                        writeln('NIK sudah pernah didaftarkan. Silakan gunakan NIK lain.');
                        restart;
                     end;
               end;
         end;
      until (angka) and (length(T[num.n].NIK)=16) and not(notAvailable);
      exit;
   end;
   
   Procedure inputNama(Var T:ArrNasabah; num:urutanRek);
   Begin
      clrscr;
      repeat
         begin
            RegisterHead;
            writeln('NIK : ', T[num.n].NIK);
            write('Nama : '); readln(T[num.n].Nama);
            if T[num.n].Nama='' then
               begin
                  write('Nama tidak boleh kosong.');
                  restart;
               end;
         end;
      until (T[num.n].Nama<>'');
      exit;
   end;

   Procedure Back;
   Begin
      writeln;
      write('Tekan [Enter] untuk kembali ke menu utama...');
   end;

   Procedure inputJenisRek(Var T:ArrNasabah; var num:urutanRek; var avail: boolean);
   Var
      ans : char;
   Begin
      avail := false;
      while not avail do
         begin
            clrscr;
            RegisterHead;
            writeln('NIK : ', T[num.n].NIK);
            writeln('Nama : ', T[num.n].Nama);
            writeln('Pilih jenis Rekening [1/2/3] : ');
            writeln('     1. Silver');
            writeln('     2. Gold');
            writeln('     3. Platinum');
            repeat
               Ans:=lowercase(readkey);
            until ans in ['1'..'3','x'];
            case ans of
               '1' : begin
                        if (num.a<MaxSGP) then 
                           begin
                              T[num.n].jenisRek := 'Silver';
                              num.a:=num.a+1;
                              T[num.n].noUrut:=num.a;
                              avail:=true;
                           end
                        else 
                           begin
                              writeln;
                              writeln('Jumlah nasabah jenis Silver telah mencapai batas maksimum.');
                              write('Silakan memilih ulang atau tekan [x] untuk kembali ke menu utama...');
                              delay(3000);
                           end;
                     end;
               '2' : begin
                        if (num.b<MaxSGP) then
                           begin
                              T[num.n].jenisRek := 'Gold';
                              num.b:=num.b+1;
                              T[num.n].noUrut:=num.b;
                              avail:=true;
                           end
                        else
                           begin
                              writeln;
                              writeln('Jumlah nasabah jenis Gold telah mencapai batas maksimum.');
                              write('Silakan memilih ulang atau tekan [x] untuk kembali ke menu utama...');
                              delay(3000);  
                           end;     
                     end;
               '3' : begin
                        if (num.c<MaxSGP) then
                           begin
                              T[num.n].jenisRek := 'Platinum';
                              num.c:=num.c+1;
                              T[num.n].noUrut:=num.c;
                              avail:=true;
                           end
                        else
                           begin
                              writeln;
                              writeln('Jumlah nasabah jenis Platinum telah mencapai batas maksimum.');
                              write('Silakan memilih ulang atau tekan [x] untuk kembali ke menu utama...');
                              delay(3000);
                           end;
                     end;
               'x' : begin 
                        T[num.n].NIK := '';
                        T[num.n].Nama := '';
                        num.n:=num.n-1;
                        back;
                        exit;
                     end;
            end;
         end;
      exit;
   end;

   Procedure GenerateNoRek(var T:ArrNasabah; num:urutanRek);
   Var
      strNoUrut : string;
   begin
      clrscr;
      RegisterHead;
      writeln('NIK : ', T[num.n].NIK);
      writeln('Nama : ', T[num.n].Nama);
      writeln('Jenis rekening : ', T[num.n].jenisRek);
      str(T[num.n].noUrut, strNoUrut);
      if T[num.n].noUrut<10 then
         begin
            T[num.n].noRek:=concat('XYZ-', T[num.n].jenisRek[1], '00', strNoUrut);
            writeln('Nomor rekening : ', T[num.n].noRek);
         end
      else if T[num.n].noUrut<100 then
         begin
            T[num.n].noRek:=concat('XYZ-', T[num.n].jenisRek[1], '0', strNoUrut);
            writeln('Nomor rekening : ', T[num.n].noRek);
         end
      else
         begin
            T[num.n].noRek:=concat('XYZ-', T[num.n].jenisRek[1], strNoUrut);
            writeln('Nomor rekening : ', T[num.n].noRek);
         end;
      writeln;
      exit;
   end;

   Procedure Register(Var T:ArrNasabah; var num:urutanRek);
   Var
      ans : char;
      avail : boolean;
   begin
      RegisterHead;
      inputNIK(T,num);
      inputNama(T,num);
      inputJenisRek(T,num, avail);
      if avail then
         begin
            T[num.n].saldo:=1000000;
            repeat
               begin
                  GenerateNoRek(T,num);
                  writeln('Apakah data sudah benar? [Y/N]');
                  repeat
                     ans:=lowercase(readkey);
                  until ans in ['y','n'];
                  case ans of
                     'y' : begin
                              clrscr;
                              RegisterHead;
                              writeln('Registrasi berhasil. Tekan [Enter] kembali ke halaman utama...');
                           end;
                     'n' : begin
                              clrscr;
                              RegisterHead;
                              writeln('Data apakah yang ingin diubah? [1/2/3]');
                              writeln('   1. NIK');
                              writeln('   2. Nama');
                              writeln('   3. Jenis rekening');
                              repeat
                                 ans:=readkey;
                              until ans in ['1'..'3'];
                              case ans of
                                 '1' : begin
                                          num.n:=num.n-1;
                                          inputNIK(T,num);
                                       end;
                                 '2' : inputNama(T,num);
                                 '3' : begin
                                          if T[num.n].jenisRek = 'Silver' then
                                             num.a:=num.a-1
                                          else if T[num.n].jenisRek = 'Gold' then
                                             num.b:=num.b-1
                                          else if T[num.n].jenisRek = 'Platinum' then
                                             num.c:=num.c-1;
                                          inputJenisRek(T,num,avail);
                                       end;
                              end;
                           end;
                  end;
               end;
            until ans='y';
            exit;
         end
      else 
         exit;
   end;

   
   Procedure TThead;
   begin
      writeln('-----------');
      writeln('Tarik Tunai');
      writeln('-----------');
      writeln;
   end;

   Function UnderLim(rek:string; jml:longint):boolean;
   Begin
      if rek[5]='S' then
         UnderLim:=(jml<=25000)
      else if rek[5]='G' then
         UnderLim:=(jml<=100000)
      else
         UnderLim:=(jml<=300000);
   end;

   Procedure LimitReg;
   Begin
      clrscr;
      RegisterHead;
      writeln('Jumlah nasabah telah melebihi batas maksimum.');
      write('Registrasi tidak dapat dilakukan lagi. Tekan [Enter] untuk kembali...');
      exit;
   end;

   Procedure TarikTunai(var T:ArrNasabah; num:urutanRek; idx:integer; rek:string);
   Var
      jml : longint;
   Begin
      repeat
         begin
            clrscr;
            TTHead;
            write('Masukkan jumlah penarikan : Rp'); readln(jml);
            writeln;
            if jml<0 then
               begin
                  write('Jumlah penarikan tunai harus di atas 0.');
                  restart;
               end
            else if (jml mod 10<>0) then
               begin
                  write('Jumlah penarikan tunai harus kelipatan 10.');
                  restart;
               end
            else if (jml>T[idx].Saldo) then
               begin
                  writeln('Jumlah penarikan tunai tidak boleh melampaui saldo.');
                  writeln('Jumlah saldo saat ini : Rp', T[idx].Saldo);
                  restart;
               end
            else if not(UnderLim(rek,jml)) then
               begin
                  writeln('Penarikan tunai melewati batas maksimal.');
                  if rek[5]='S' then
                     writeln('Batas maksimal penarikan tunai jenis rekening anda (Silver) adalah Rp25.000')
                  else if rek[5]='G' then
                     writeln('Batas maksimal penarikan tunai jenis rekening anda (Gold) adalah Rp100.000')
                  else
                     writeln('Batas maksimal penarikan tunai jenis rekening anda (Platinum) adalah Rp300.000');
                  writeln;
                  restart;
               end;
         end;
      until (jml mod 10 = 0) and (jml>0) and (jml<T[idx].Saldo) and (UnderLim(rek,jml));
      clrscr;
      TTHead;
      writeln('Penarikan tunai berhasil.');
      T[idx].Saldo:=T[idx].Saldo-jml;
      writeln('Jumlah saldo saat ini : ', T[idx].Saldo);
      back;
      exit;
   end;

   Procedure CekRekening(Var T:ArrNasabah; num:urutanRek);
   Var
      rek : string;
      ans : char;
      idx : integer;
   Begin
      repeat
         begin
            clrscr;
            TThead;
            write('Masukkan nomor rekening : '); readln(rek);
            idx := SeqSearch(T,num.n,rek);
            if (idx = 0) then
               begin
                  clrscr;
                  TThead;
                  writeln('Nomor rekening belum terdaftar. Silakan pilih tindakan [1/2].');
                  writeln('   1. Masukkan nomor rekening lain.');
                  writeln('   2. Kembali ke menu utama.');
                  repeat
                     ans:=readkey;
                  until ans in ['1','2'];
                  case ans of
                     '1' : begin
                              writeln;
                              writeln('Silakan masukkan kembali nomor rekening...');
                              delay(1000);
                           end;
                     '2' : begin
                              back;
                              exit;
                           end;
                  end;
               end;
         end;
      until (idx <> 0);
      TarikTunai(T,num,idx,rek);
   end;

   Procedure SearchingHead;
   begin
      writeln('---------');
      writeln('Pencarian');
      writeln('---------');
      writeln;
   end;

   Procedure TableHead;
   Begin
      writeln;
      writeln(' ___________________________________________________________________________________________________________');
      writeln('||          Nama          ||         NIK        ||   Nomor Rekening  ||   Jenis Rekening   ||     Saldo    ||');
      writeln('||________________________||____________________||___________________||____________________||______________||');
   end;

   Procedure TableFoot;
   Begin
      writeln('||________________________||____________________||___________________||____________________||______________||')
   end;

   Procedure TampilkanData(i:integer; T:ArrNasabah; y:integer);
   Begin
      gotoxy(1,y);
      write('||  ', T[i].Nama);
      gotoxy(27,y);
      write('||  ', T[i].NIK);
      gotoxy(49,y);
      write('||  ', T[i].noRek);
      gotoxy(70,y);
      write('||  ', T[i].jenisRek);
      gotoxy(92,y);
      write('||  ', 'Rp', T[i].saldo);
      gotoxy(108,y);
      writeln('||');
   end;

   Procedure CariData(T:ArrNasabah; num:urutanRek);
   Var
      y, i, idx :integer;
      cari:string;
      ans:char;
   Begin
      repeat
         begin
            clrscr;
            SearchingHead;
            writeln('Cari nasabah berdasarkan [1/2/3] : ');
            writeln('   1. Nama');
            writeln('   2. NIK');
            writeln('   3. Nomor rekening');
            repeat
               ans:=readkey;
            until ans in ['1'..'3'];
            case ans of
               '1' : begin
                        clrscr;
                        SearchingHead;
                        y:=10;
                        write('Masukkan nama yang ingin dicari : '); readln(cari);
                        TableHead;
                        for i:=1 to num.n do
                           if (lowercase(T[i].nama) = lowercase(cari)) then
                              begin
                                 TampilkanData(i,T,y);
                                 y:=y+1;
                              end;
                        TableFoot;
                     end;
               '2' : begin
                        clrscr;
                        SearchingHead;
                        y:=10;
                        write('Masukkan NIK yang ingin dicari : '); readln(cari);
                        TableHead;
                        idx := SeqSearch(T, num.n, cari);
                        if (idx <> 0) then
                              TampilkanData(idx,T,y);
                        TableFoot;
                     end;
               '3' : begin
                        clrscr;
                        SearchingHead;
                        y:=10;
                        write('Masukkan nomor rekening yang ingin dicari : '); readln(cari);
                        TableHead;
                        idx := SeqSearch(T, num.n, cari);
                        if (idx <> 0) then
                              TampilkanData(idx,T,y);
                        TableFoot;
                     end;
            end;
            writeln;
            writeln('Cari data nasabah lain lagi? [Y/N]');
            repeat
               ans:=lowercase(readkey);
            until ans in ['y','n'];
            if ans='n' then
               back;
         end;
      until ans = 'n';
      exit;
   end;

Procedure DataHead;
   begin
      writeln('------------');
      writeln('Data Nasabah');
      writeln('------------');
      writeln;
   end;

Procedure InstSort(data:string; num:urutanRek; var T:ArrNasabah);
   Var
      i,pass :integer;
      temp:dataNasabah;
   Begin
      case data of
         'nama' : begin
                     for pass:=2 to num.n do
                        begin
                           temp:=T[pass];
                           i:=pass-1;
                           while (lowercase(T[i].nama) > lowercase(temp.nama)) and (i>0) do
                              begin
                                 T[i+1]:=T[i];
                                 i:=i-1;
                              end;
                           T[i+1]:=temp;
                        end;
                  end;
         'saldo': begin
                     for pass:=2 to num.n do
                        begin
                           temp:=T[pass];
                           i:=pass-1;
                           while (T[i].saldo > temp.saldo) and (i>0) do
                              begin
                                 T[i+1]:=T[i];
                                 i:=i-1;
                              end;
                           T[i+1]:=temp;
                        end;
                  end;
      end;
   end;

   Procedure SelSort(data:string; num:urutanRek; var T:ArrNasabah);
   Var
      n,i,pass,min:integer;
      temp:dataNasabah;
   Begin
   n:=num.n;
   case data of
      'nama' : begin
                  for pass:=1 to (n-1) do
                     begin
                        min:=pass;
                        for i:=pass+1 to n do  
                           if (lowercase(T[min].nama) > lowercase(T[i].nama)) then
                              min:=i;
                        temp:=T[min];
                        T[min]:=T[pass];
                        T[pass]:=temp;            
                     end;
               end;
      'saldo': begin
                  for pass:=1 to (n-1) do
                     begin
                        min:=pass;
                        for i:=pass+1 to n do
                           if T[min].saldo > T[i].saldo then
                              min:=i;
                        temp:=T[min];
                        T[min]:=T[pass];
                        T[pass]:=temp;
                              
                     end;
               end;
      end;
   end;

   Procedure Data(jenis:char; num:urutanRek; T:ArrNasabah);
   Var
      y, i : integer;
      ans : char;
   Begin
      repeat
         begin
            clrscr;
            Datahead;
            y:=8;
            TableHead;
            case jenis of
               's' : begin
                        for i:=1 to num.n do
                           if T[i].jenisRek = 'Silver' then
                              begin
                                 y:=y+1;
                                 TampilkanData(i, T, y);
                              end;
                        TableFoot;
                     end;
               'g' : begin
                        for i:=1 to num.n do
                           if T[i].jenisRek = 'Gold' then
                              begin
                                 y:=y+1;
                                 TampilkanData(i, T, y);
                              end;
                        TableFoot;
                     end;
               'p' : begin
                        for i:=1 to num.n do
                           if T[i].jenisRek = 'Platinum' then
                              begin
                                 y:=y+1;
                                 TampilkanData(i, T, y);
                              end;
                        TableFoot;
                     end;
               'a' : begin
                        for i:=1 to num.n do
                           begin
                              y:=y+1;
                              TampilkanData(i,T,y);
                           end;
                        TableFoot;
                     end;
            end;
            writeln;
            writeln('Pilih tindakan [1/2/3] :');
            writeln('   1. Urutkan berdasarkan nama');
            writeln('   2. Urutkan berdasarkan jumlah saldo');
            writeln('   3. Kembali ke menu utama');
            repeat
               ans:=readkey;
            until ans in ['1','2','3'];
            case ans of
               '1' : begin
                        if not(jenis='a') then
                           InstSort('nama', num, T)
                        else
                           SelSort('nama', num, T);
                     end;
               '2' : begin
                        if not(jenis='a') then
                           SelSort('saldo', num, T)
                        else
                           InstSort('saldo',num, T);
                     end;
               '3' : back;
            end;
         end;
      until ans='3';
      exit;
   end;

   Procedure Head;
   begin
      writeln('                ||||||||||||||');
      writeln('                || BANK XYZ ||');
      writeln('                ||||||||||||||');
      writeln;
   end;

   Procedure jmlNasabah(T:ArrNasabah; num:urutanRek);
   Var 
      i:integer;
      TotalDana:longint;
   Begin
      TotalDana:=0;
      writeln('                JUMLAH NASABAH');
      writeln('----------------------------------------------------');
      writeln('              1. Silver   : ', num.a);
      writeln('              2. Gold     : ', num.b);
      writeln('              3. Platinum : ', num.c);
      writeln('[Tekan S/G/P untuk melihat daftar nasabah per jenis]');
      writeln('----------------------------------------------------');
      writeln('   Jumlah seluruh nasabah : ', num.n);
      for i:=1 to num.n do
         TotalDana:=TotalDana+T[i].Saldo;
      writeln('       Total dana nasabah : Rp', TotalDana);
      writeln('[Tekan A untuk melihat daftar seluruh nasabah]');
      writeln('----------------------------------------------------');
      writeln;
   end;

//PROGRAM UTAMA
begin
   numUrut.a := 0;
   numUrut.b := 0;
   numUrut.c := 0;
   numUrut.n := numUrut.a + numUrut.b + numUrut.c;
   login;
   while true do 
      begin
         clrscr;
         head;
         jmlNasabah(TNasabah,numUrut);
         writeln('Selamat datang di menu utama. Silakan memilih tindakan [1/2/3/4].');
         writeln('    [1.] Pendaftaran nasabah baru');
         writeln('    [2.] Tarik tunai');
         writeln('    [3.] Lihat data nasabah tertentu');
         writeln('    [4.] Exit');
         repeat
            key:=lowercase(readkey);
         until key in ['s','g','p','a','1'..'4'];
         case key of
              '1' : If (numUrut.n<nMax) then
                       Register(TNasabah,numUrut)
                    else
                       LimitReg;
              '2' : CekRekening(TNasabah,numUrut);
              '3' : CariData(TNasabah,numUrut);
              's', 'g', 'p', 'a' : Data(key,numUrut,TNasabah);
              '4' : halt(1);
         end;
         readln;
      end;
end.






 