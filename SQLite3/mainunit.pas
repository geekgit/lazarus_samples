unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sqlite3DS, sqlite3conn, sqldb, Forms, Controls, Graphics,
  Dialogs, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    DeleteFileButton: TButton;
    CreateDBButton: TButton;
    function GetDBFileName():string;
    procedure CreateDBButtonClick(Sender: TObject);
    procedure DeleteFileButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateDB();
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

function TMainForm.GetDBFileName():string;
begin
  Result:='test.db';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
     CreateDBButton.Caption:=format('Создать БД (%s)',[GetDBFileName()]);
     DeleteFileButton.Caption:=format('Удалить файл %s',[GetDBFileName()]);

end;

procedure TMainForm.CreateDBButtonClick(Sender: TObject);
begin
  try
     CreateDB();
  except
    on E: Exception do
       begin
         ShowMessage(E.Message);
       end;
  end;
end;

procedure TMainForm.DeleteFileButtonClick(Sender: TObject);
var
  Success: Boolean;
begin
  Success:=DeleteFile(GetDBFileName());
  if Success then ShowMessage(format('Файл %s удалён.',[GetDBFileName()]))
  else ShowMessage(format('Не удалось удалить файл %s!',[GetDBFileName()]));
end;

procedure TMainForm.CreateDB();
var
  Conn: TSQLite3Connection;
  Query: TSQLQuery;
  Transaction: TSQLTransaction;
begin
  if not(FileExists(GetDBFileName())) then
    begin
      Conn:=TSQLite3Connection.Create(nil);
      Conn.DatabaseName:=GetDBFileName();
      Conn.Connected:=True;
      Transaction:=TSQLTransaction.Create(nil);
      Transaction.DataBase:=Conn;
      Query:=TSQLQuery.Create(nil);
      Query.Transaction:=Transaction;
      Query.DataBase:=Conn;
      Query.SQL.Add('create table cargo (id INTEGER PRIMARY KEY, text VARCHAR(30), weight INTEGER)');
      Query.ExecSQL;
      Transaction.Commit;
      Query.Close;
      ShowMessage(format('База данных %s создана.',[GetDBFileName()]));
    end
  else
  begin
    ShowMessage(format('%s уже существует!',[GetDBFileName()]));
  end;
end;

end.

