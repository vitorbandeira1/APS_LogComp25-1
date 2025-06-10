; LLVM IR gerado pelo compilador submarino
declare i32 @printf(i8*, ...)
@str0 = private unnamed_addr constant [25 x i8] c"[NAV] indo para (%d,%d)\0A\00"
@str1 = private unnamed_addr constant [22 x i8] c"[NAV] acelerando: %d\0A\00"
@str2 = private unnamed_addr constant [13 x i8] c"[STATUS] %s\0A\00"
@str3 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
define i32 @main() {
  ; Imprimindo mensagem: "Subindo..."
  %tmp4 = call i32 (i8*, ...) @printf(i8* getelementptr ([12 x i8], [12 x i8]* @str4, i32 0, i32 0))
  ; Imprimindo mensagem: "Descendo..."
  %tmp5 = call i32 (i8*, ...) @printf(i8* getelementptr ([13 x i8], [13 x i8]* @str5, i32 0, i32 0))
  ; Imprimindo mensagem: "Inclinando para manobra"
  %tmp6 = call i32 (i8*, ...) @printf(i8* getelementptr ([25 x i8], [25 x i8]* @str6, i32 0, i32 0))
  ; Imprimindo mensagem: "Parando..."
  %tmp7 = call i32 (i8*, ...) @printf(i8* getelementptr ([12 x i8], [12 x i8]* @str7, i32 0, i32 0))
  ret i32 0
}
@str4 = private unnamed_addr constant [12 x i8] c"Subindo...\0A\00"
@str5 = private unnamed_addr constant [13 x i8] c"Descendo...\0A\00"
@str6 = private unnamed_addr constant [25 x i8] c"Inclinando para manobra\0A\00"
@str7 = private unnamed_addr constant [12 x i8] c"Parando...\0A\00"
