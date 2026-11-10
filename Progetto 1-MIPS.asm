# ==========================================
# COSTANTI GLOBALI
# ==========================================
.eqv NUM_STUDENTS  50      # Numero di studenti presenti nel DB al popolamento
.eqv STUDENT_SIZE  900     # Dimensione in byte di ogni record studente (84 + 20*40 + 16 padding)
.eqv START_ID      1000    # ID matricola di partenza per gli studenti
.eqv MAX_STUDENTS  100     # Numero massimo di studenti contenibili nel DB
.eqv MAX_EXAMS_LIMIT 20    # Numero massimo di esami registrabili per studente
.eqv TOTAL_DB_SIZE 90000   # Spazio allocato nel DB (MAX_STUDENTS * STUDENT_SIZE)
.eqv DUMMY_AGE       20      # Età di default per il popolamento
.eqv DUMMY_YEAR      2025    # Anno di immatricolazione di default
.eqv STATUS_ACTIVE   1       # Flag di stato: 1 = Attivo, 0 = Eliminato logicamente
.eqv DUMMY_EXAMS_N   1       # Numero di esami superati al momento del popolamento
.eqv DUMMY_EXAM_CREDITS  6      # Crediti di default per l'esame fittizio
.eqv DUMMY_BASE_GRADE   18      # Voto minimo base per il popolamento fittizio
.eqv DUMMY_GRADE_RANGE  14      # Offset per generazione pseudo-casuale dei voti
.eqv MIN_GRADE          18      # Voto minimo per superare un esame
.eqv MAX_GRADE          31      # Voto massimo (31 = 30 e lode)
.eqv MIN_YEAR      1950      # Anno minimo di immatricolazione
.eqv MAX_YEAR      2026      # Anno massimo di immatricolazione
.eqv MIN_AGE       16        # Età minima consentita
.eqv MAX_AGE       100       # Età massima consentita
.eqv MAX_STR_LEN  31         # Lunghezza massima stringhe (32 byte - 1 per il terminatore '\0')
.eqv ASCII_MIN_LOWER   97      # Valore ASCII per la lettera 'a'
.eqv ASCII_MAX_LOWER   122     # Valore ASCII per la lettera 'z'

# --- Costanti Offset Studente (84 byte base) ---
.eqv OFF_ID        0
.eqv OFF_NAME      4
.eqv OFF_SURNAME   36
.eqv OFF_AGE       68
.eqv OFF_YEAR      72
.eqv OFF_STATUS    76
.eqv OFF_EXAMS_N   80
.eqv OFF_EXAMS_A   84      # Indirizzo di base dell'array degli esami per lo studente

# --- Costanti Offset Esame (40 byte per esame) ---
.eqv EXAM_CREDITS  32      
.eqv EXAM_GRADE    36      
.eqv EXAM_SIZE     40      

.data
    # ==========================================
    # DATABASE E VARIABILI GLOBALI
    # ==========================================
    student_db: .space TOTAL_DB_SIZE
    total_students_inserted: .word 0   # Contatore globale dei record validi nel DB

    # ==========================================
    # STRINGHE DEL MENU E UTILI
    # ==========================================
    menu_title: .asciiz "\n--- University Student Information System ---\n"
    menu_0:  .asciiz "0. Popola il database\n"
    menu_1:  .asciiz "1. Inserisci un nuovo studente\n"
    menu_2:  .asciiz "2. Stampa tutti gli studenti\n"
    menu_3:  .asciiz "3. Cerca studente per ID\n"
    menu_4:  .asciiz "4. Cerca studenti per cognome\n"
    menu_5:  .asciiz "5. Aggiungi un esame superato a uno studente\n"
    menu_6:  .asciiz "6. Modifica informazioni personali studente\n"
    menu_7:  .asciiz "7. Elimina logicamente uno studente\n"
    menu_8:  .asciiz "8. Calcola media ponderata per uno studente\n"
    menu_9:  .asciiz "9. Trova il miglior studente per media ponderata\n"
    menu_10: .asciiz "10. Calcola totale crediti per uno studente\n"
    menu_11: .asciiz "11. Stampa studenti sopra una certa soglia di media\n"
    menu_12: .asciiz "12. Stampa studenti con almeno N esami superati\n"
    menu_13: .asciiz "13. Ordina studenti per ID\n"
    menu_14: .asciiz "14. Ordina studenti per media ponderata\n"
    menu_15: .asciiz "15. Stampa statistiche globali\n"
    menu_16: .asciiz "16. Esporta report compatto\n"
    menu_17: .asciiz "17. Stampa ricorsiva esami di uno studente\n"
    menu_18: .asciiz "18. Esci dal programma\n"
    prompt:  .asciiz "\nSeleziona un'opzione: "
    
    msg_populated: .asciiz "\n[OK] Database popolato con degli studenti fittizi.\n"
    msg_not_impl:  .asciiz "\n[!] Funzionalita' non ancora implementata.\n"
    msg_exit:      .asciiz "\nUscita in corso...\n"
    
    name_dummy:      .asciiz "Mario"
    surname_dummy:   .asciiz "Rossi"
    exam_name_dummy: .asciiz "Fondamenti di Informatica"
    
    # ==========================================
    # STRINGHE DI FORMATTAZIONE STAMPA
    # ==========================================
    str_empty_db: .asciiz "\nNessuno studente presente nel database.\n"
    str_sep:      .asciiz "----------------------------------------\n"
    str_id:       .asciiz "ID: "
    str_nome:     .asciiz " | Nome: "
    str_cognome:  .asciiz " | Cognome: "
    str_eta:      .asciiz " | Eta': "
    str_anno:     .asciiz " | Anno Imm.: "
    str_esami:    .asciiz " | Esami Superati: "
    str_newline:  .asciiz "\n"
    
    # ==========================================
    # STRINGHE INPUT UTENTE
    # ==========================================
    prompt_id:        .asciiz "\nInserisci ID Studente: "
    prompt_nome:      .asciiz "Inserisci Nome (max 31 caratt.): "
    prompt_cognome:   .asciiz "Inserisci Cognome (max 31 caratt.): "
    prompt_eta:       .asciiz "Inserisci Eta' (16-100): "
    prompt_anno:      .asciiz "Inserisci Anno di immatricolazione (1950-2026): "
    msg_success:      .asciiz "\n[OK] Studente inserito con successo!\n"
    msg_db_full:      .asciiz "\n[ERRORE] Il database e' pieno! Impossibile inserire.\n"
    msg_id_exists:    .asciiz "\n[ERRORE] L'ID inserito e' gia' presente nel database!\n" # <--- AGGIUNGI QUESTA RIGA
    
    # ==========================================
    # STRINGHE RICERCA 
    # ==========================================
    prompt_search_id: .asciiz "\nInserisci l'ID dello studente da cercare: "
    msg_not_found:    .asciiz "\n[!] Nessuno studente attivo trovato con questo criterio.\n"
    msg_found:        .asciiz "\n[OK] Studente trovato:\n"
    prompt_search_sur:.asciiz "\nInserisci il cognome da cercare: "
    msg_found_sur:    .asciiz "\n[OK] Studenti trovati con questo cognome:\n"
    search_buffer:    .space 32  # Buffer allocato per il match esatto delle stringhe
    
    # ==========================================
    # STRINGHE AGGIUNTA ESAME 
    # ==========================================
    prompt_add_exam_id: .asciiz "\nInserisci l'ID dello studente a cui aggiungere l'esame: "
    prompt_exam_name:   .asciiz "Inserisci il nome dell'esame (max 31 caratt.): "
    prompt_exam_cred:   .asciiz "Inserisci i crediti dell'esame: "
    msg_invalid_cred:  .asciiz "[!] I crediti non sono validi. Devono essere maggiori di 0.\n"
    prompt_exam_grade:  .asciiz "Inserisci il voto dell'esame (es. 18-31) (31=30L): "
    msg_max_exams:      .asciiz "\n[ERRORE] Lo studente ha gia' raggiunto il limite massimo di 20 esami!\n"
    msg_exam_added:     .asciiz "\n[OK] Esame aggiunto con successo allo studente!\n"
    msg_invalid_grade:  .asciiz "[!] Voto non valido. Inserisci un valore tra 18 e 31 (31 = 30L).\n"
    
    # ==========================================
    # STRINGHE MODIFICA 
    # ==========================================
    prompt_edit_id:   .asciiz "\nInserisci l'ID dello studente da modificare: "
    msg_edit_success: .asciiz "\n[OK] Dati personali dello studente aggiornati con successo!\n"
    msg_invalid_age:  .asciiz "[!] Eta' non valida. Inserisci un valore tra 16 e 100.\n"
    msg_invalid_year: .asciiz "[!] Anno non valido. Inserisci un valore tra 1950 e 2026.\n"

    # ==========================================
    # STRINGHE ELIMINAZIONE
    # ==========================================
    prompt_delete_id:   .asciiz "\nInserisci l'ID dello studente da eliminare: "
    msg_delete_success: .asciiz "\n[OK] Studente eliminato logicamente con successo!\n"
    
    # ==========================================
    # STRINGHE CALCOLO MEDIA
    # ==========================================
    prompt_gpa_id:      .asciiz "\nInserisci l'ID dello studente per il calcolo della media: "
    msg_gpa_result:     .asciiz "\nLa media ponderata dello studente e': "
    msg_no_exams:       .asciiz "\n[!] Lo studente non ha ancora sostenuto esami. Impossibile calcolare la media.\n"
    
    # ==========================================
    # STRINGHE TROVA MIGLIOR STUDENTE
    # ==========================================
    msg_best_student: .asciiz "\n[OK] Miglior media assoluta registrata: "
    msg_best_list:    .asciiz "\nStudenti che hanno raggiunto questo record:\n"
    msg_no_best:      .asciiz "\n[!] Impossibile determinare il migliore (nessun esame registrato nel DB).\n"

    # ==========================================
    # STRINGHE TOTALE CREDITI
    # ==========================================
    prompt_cred_id:  .asciiz "\nInserisci l'ID dello studente per calcolare i crediti: "
    msg_tot_credits: .asciiz "\nIl totale dei crediti acquisiti dallo studente e': "
   
    # ==========================================
    # STRINGHE SOGLIA MEDIA 
    # ==========================================
    prompt_threshold:    .asciiz "\nInserisci la soglia di media: "
    msg_above_threshold: .asciiz "\n[OK] Studenti con media uguale o superiore alla soglia:\n"
    msg_none_above:      .asciiz "\n[!] Nessuno studente soddisfa questo criterio.\n"
   
    # ==========================================
    # STRINGHE SOGLIA ESAMI 
    # ==========================================
    prompt_exams_threshold: .asciiz "\nInserisci il numero minimo di esami superati: "
    msg_above_exams:        .asciiz "\n[OK] Studenti con almeno questo numero di esami:\n"
   
    # ==========================================
    # STRINGHE ORDINAMENTO
    # ==========================================
    msg_sort_success: .asciiz "\n[OK] Database ordinato con successo!\n"
   
   # ==========================================
    # STRINGHE STATISTICHE 
    # ==========================================
    msg_stat_title:     .asciiz "\n--- Statistiche Globali dell'Ateneo ---\n"
    msg_stat_tot:       .asciiz "Totale Studenti Attivi: "
    msg_stat_age:       .asciiz "Età Media degli Studenti Attivi: "
    msg_stat_exams_avg: .asciiz "Media Esami Superati per Studente: "
    msg_stat_avg:       .asciiz "Media Ponderata Globale d'Ateneo: "
    msg_stat_no_avg:    .asciiz "[!] Nessun esame registrato. Impossibile calcolare la media globale.\n"
  
    # ==========================================
    # STRINGHE REPORT COMPATTO
    # ==========================================
    msg_report_title: .asciiz "\n--- Report Compatto (Formato CSV) ---\n"
    str_comma:        .asciiz ","
     
    # ==========================================
    # STRINGHE STAMPA RICORSIVA 
    # ==========================================
    prompt_rec_id: .asciiz "\nInserisci l'ID dello studente: "
    msg_rec_title: .asciiz "\n--- Libretto Esami (Stampato in Ordine Inverso via Ricorsione) ---\n"
    str_cred_rec:  .asciiz " | Crediti: "
    str_voto_rec:  .asciiz " | Voto: " 
     
.text
.globl main

main:
menu_loop:
    li $v0, 4
    la $a0, menu_title
    syscall
    la $a0, menu_0
    syscall
    la $a0, menu_1
    syscall
    la $a0, menu_2
    syscall
    la $a0, menu_3
    syscall
    la $a0, menu_4
    syscall
    la $a0, menu_5
    syscall
    la $a0, menu_6
    syscall
    la $a0, menu_7
    syscall
    la $a0, menu_8
    syscall
    la $a0, menu_9
    syscall
    la $a0, menu_10
    syscall
    la $a0, menu_11
    syscall
    la $a0, menu_12
    syscall
    la $a0, menu_13
    syscall
    la $a0, menu_14
    syscall
    la $a0, menu_15
    syscall
    la $a0, menu_16
    syscall
    la $a0, menu_17
    syscall
    la $a0, menu_18
    syscall
    
    la $a0, prompt
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0
    
    beq $s0, 0, feat_0_populate
    beq $s0, 1, feat_1_insert
    beq $s0, 2, feat_2_print_all
    beq $s0, 3, feat_3_search_id
    beq $s0, 4, feat_4_search_surname
    beq $s0, 5, feat_5_add_exam
    beq $s0, 6, feat_6_edit_student
    beq $s0, 7, feat_7_delete_student
    beq $s0, 8, feat_8_calc_gpa
    beq $s0, 9, feat_9_best_student
    beq $s0, 10, feat_10_tot_credits
    beq $s0, 11, feat_11_threshold
    beq $s0, 12, feat_12_exams_threshold
    beq $s0, 13, feat_13_sort_id
    beq $s0, 14, feat_14_sort_gpa
    beq $s0, 15, feat_15_stats
    beq $s0, 16, feat_16_report
    beq $s0, 17, feat_17_recursive
    beq $s0, 18, exit_program
    
    j not_implemented

# ==========================================
# 0. POPOLAMENTO
# ==========================================
feat_0_populate:
    la $t0, student_db              # Inizializzazione puntatore alla base del DB
    li $t1, 0                       # Inizializzazione contatore ciclo esterno (i = 0)
    li $t2, NUM_STUDENTS            

populate_loop:
    bge $t1, $t2, end_populate      # Condizione di uscita: limite di studenti fittizi raggiunto
    
    addi $t3, $t1, START_ID         # Calcolo progressivo matricola
    sw $t3, OFF_ID($t0)   
            
    li $t3, DUMMY_AGE               
    sw $t3, OFF_AGE($t0)
    
    li $t3, DUMMY_YEAR              
    sw $t3, OFF_YEAR($t0)
    
    li $t3, STATUS_ACTIVE           
    sw $t3, OFF_STATUS($t0)
    
    li $t3, DUMMY_EXAMS_N           
    sw $t3, OFF_EXAMS_N($t0)

    la $a0, name_dummy              
    addi $a1, $t0, OFF_NAME         # Indirizzo di offset per il campo Nome
    li $a2, MAX_STR_LEN             
    jal sub_copy_string             

    la $a0, surname_dummy
    addi $a1, $t0, OFF_SURNAME      # Indirizzo di offset per il campo Cognome
    li $a2, MAX_STR_LEN
    jal sub_copy_string

    la $a0, exam_name_dummy
    addi $a1, $t0, OFF_EXAMS_A      # Indirizzo di offset per l'inizio dell'array Esami
    li $a2, MAX_STR_LEN
    jal sub_copy_string
    
    addi $t9, $t0, OFF_EXAMS_A      # Salvataggio in $t9 dell'indirizzo base per i dati del primo esame
    
    li $t3, DUMMY_EXAM_CREDITS      
    sw $t3, EXAM_CREDITS($t9)
    
    li $t4, DUMMY_GRADE_RANGE   
    div $t1, $t4                
    mfhi $t3                        # Estrazione del resto della divisione per varianza dei voti
    addi $t3, $t3, DUMMY_BASE_GRADE # Generazione pseudo-casuale del voto limitato a MAX_GRADE
    sw $t3, EXAM_GRADE($t9)     

    addi $t1, $t1, 1                # Incremento contatore ciclo
    addi $t0, $t0, STUDENT_SIZE     # Avanzamento del puntatore al blocco di memoria del prossimo studente
    j populate_loop

end_populate:
    la $t0, total_students_inserted
    sw $t1, 0($t0)                  # Aggiornamento contatore globale studenti attivi
    
    li $v0, 4
    la $a0, msg_populated
    syscall
    
    j menu_loop

# ==========================================
# 1. INSERIMENTO STUDENTE
# ==========================================
feat_1_insert:
    la $t0, total_students_inserted  
    lw $t1, 0($t0)                  # Caricamento del numero effettivo di record presenti
    li $t2, MAX_STUDENTS   
    bge $t1, $t2, db_is_full        # Controllo anti-overflow del database
    
read_insert_id:
    li $v0, 4
    la $a0, prompt_id
    syscall
    li $v0, 5     
    syscall
    
    # --- INIZIO CONTROLLO DUPLICATO ---
    addi $sp, $sp, -4
    sw $v0, 0($sp)                  # Salviamo temporaneamente l'ID nello stack
    
    move $a0, $v0                   # Passiamo l'ID come parametro alla ricerca
    jal sub_find_student_by_id
    
    lw $t9, 0($sp)                  # Recuperiamo l'ID verificato dallo stack in $t9
    addi $sp, $sp, 4
    
    bne $v0, $zero, id_already_exists # Se $v0 non è 0, lo studente esiste già!
    # --- FINE CONTROLLO DUPLICATO ---
    
    li $t3, STUDENT_SIZE   
    mul $t4, $t1, $t3               # Calcolo offset progressivo: studenti_presenti * dimensione_record
    la $t5, student_db     
    add $t5, $t5, $t4               # Puntatore assoluto alla cella di memoria libera ($t5)
    
    sw $t9, OFF_ID($t5)             # Salvataggio dell'ID verificato in memoria
    
    li $v0, 4
    la $a0, prompt_nome
    syscall
    
    li $v0, 8  
    addi $a0, $t5, OFF_NAME  
    li $a1, MAX_STR_LEN  
    addi $a1, $a1, 1                # Compensazione offset per allocazione del terminatore '\0'
    syscall
    
    addi $a0, $t5, OFF_NAME         # Re-inizializzazione argomento per sub_remove_newline
    jal sub_remove_newline  

    li $v0, 4
    la $a0, prompt_cognome
    syscall
    li $v0, 8
    addi $a0, $t5, OFF_SURNAME
    li $a1, MAX_STR_LEN  
    addi $a1, $a1, 1 
    syscall
    
    addi $a0, $t5, OFF_SURNAME      # Re-inizializzazione argomento per sub_remove_newline
    jal sub_remove_newline
    
read_insert_age:
    li $v0, 4
    la $a0, prompt_eta
    syscall
    li $v0, 5
    syscall
    blt $v0, MIN_AGE, inv_insert_age  # Validazione range età (limite inferiore)
    bgt $v0, MAX_AGE, inv_insert_age  # Validazione range età (limite superiore)
    sw $v0, OFF_AGE($t5)
    j read_insert_year

inv_insert_age:
    li $v0, 4
    la $a0, msg_invalid_age
    syscall
    j read_insert_age

read_insert_year:
    li $v0, 4
    la $a0, prompt_anno
    syscall
    li $v0, 5
    syscall
    blt $v0, MIN_YEAR, inv_insert_year  # Validazione anno immatricolazione (limite inferiore)
    bgt $v0, MAX_YEAR, inv_insert_year  # Validazione anno immatricolazione (limite superiore)
    sw $v0, OFF_YEAR($t5)
    j finish_insert

inv_insert_year:
    li $v0, 4
    la $a0, msg_invalid_year
    syscall
    j read_insert_year

finish_insert:
    li $t6, 1
    sw $t6, OFF_STATUS($t5)         # Flaggatura dello studente come logicamente attivo
    li $t6, 0
    sw $t6, OFF_EXAMS_N($t5)        # Azzeramento preventivo esami passati
    
    addi $t1, $t1, 1
    la $t0, total_students_inserted
    sw $t1, 0($t0)                  # Aggiornamento contatore globale di riempimento DB
    
    li $v0, 4
    la $a0, msg_success
    syscall
    j menu_loop
    
db_is_full:
    li $v0, 4
    la $a0, msg_db_full
    syscall
    j menu_loop

id_already_exists:
    li $v0, 4
    la $a0, msg_id_exists
    syscall
    j read_insert_id                # Loop per far inserire nuovamente un ID valido

# ==========================================
# 2. STAMPA TUTTI
# ==========================================
feat_2_print_all:
    la $t0, total_students_inserted
    lw $t2, 0($t0) 
    beq $t2, $zero, db_is_empty
    
    li $v0, 4
    la $a0, str_newline
    syscall
    la $a0, str_sep
    syscall
    
    la $t0, student_db              # Inizializzazione puntatore alla base del DB
    li $t1, 0                       # Inizializzazione contatore ciclo

print_loop:
    bge $t1, $t2, end_print         # Condizione di uscita: fine records
    
    lw $t6, OFF_STATUS($t0) 
    beq $t6, $zero, skip_student    # Salto iterazione se lo studente è logicamente inattivo
    
    move $a0, $t0                   # Passaggio indirizzo base studente come argomento
    jal sub_print_student           

skip_student:
    addi $t1, $t1, 1                # Incremento contatore ciclo
    addi $t0, $t0, STUDENT_SIZE     # Avanzamento del puntatore al blocco di memoria successivo
    j print_loop

db_is_empty:
    li $v0, 4
    la $a0, str_empty_db
    syscall

end_print:
    li $v0, 4
    la $a0, str_sep
    syscall
    j menu_loop

# ==========================================
# 3. CERCA PER ID
# ==========================================
feat_3_search_id:
    li $v0, 4
    la $a0, prompt_search_id
    syscall
    li $v0, 5 
    syscall
    move $a0, $v0
    jal sub_find_student_by_id
    
    move $t0, $v0
    beq $t0, $zero, feat_3_not_found

    li $v0, 4
    la $a0, msg_found
    syscall

    move $a0, $t0                   # Restituzione esito positivo, procedo alla stampa
    jal sub_print_student

    li $v0, 4
    la $a0, str_newline
    syscall
    j menu_loop

feat_3_not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j menu_loop

# ==========================================
# 4. CERCA PER COGNOME
# ==========================================
feat_4_search_surname:
    li $v0, 4
    la $a0, prompt_search_sur
    syscall
    
    li $v0, 8
    la $a0, search_buffer           # Memorizzazione stringa target in un buffer volatile
    li $a1, MAX_STR_LEN  
    addi $a1, $a1, 1 
    syscall
    
    la $a0, search_buffer
    jal sub_remove_newline          # Sanificazione stringa inserita per pulizia \n
    
    la $t0, student_db
    li $t1, 0  
    la $t8, total_students_inserted
    lw $t2, 0($t8) 
    li $s0, 0                       # Flag di avvenuto matching (0 = No, 1 = Sì)

search_sur_loop:
    bge $t1, $t2, end_sur_search    
    
    lw $t4, OFF_STATUS($t0)                 
    beq $t4, $zero, next_sur_search # Salto iterazione se lo studente è logicamente inattivo
    
    la $t8, search_buffer
    addi $t9, $t0, OFF_SURNAME      # Acquisizione offset del campo cognome da ispezionare
    
compare_loop:
    lb $a0, 0($t8)                  # Carica il byte della stringa cercata dall'utente
    jal sub_toupper                 # Chiama la subroutine
    move $t5, $v0                   # Salva il risultato in $t5 (convertito in maiuscolo)
    
    lb $a0, 0($t9)                  # Carica il byte del cognome dal Database
    jal sub_toupper                 # Chiama la subroutine
    move $t6, $v0                   # Salva il risultato in $t6 (convertito in maiuscolo)
    
    bne $t5, $t6, next_sur_search   # Branch su disuguaglianza (miss)
    beq $t5, $zero, surname_match   # Matching completo: raggiunto il terminatore in sincrono
    
    addi $t8, $t8, 1                # Incremento puntatore cursore target
    addi $t9, $t9, 1                # Incremento puntatore cursore db
    j compare_loop

surname_match:
    bne $s0, $zero, skip_sur_header # Prevenzione stampa ripetuta dell'header esito
    li $v0, 4
    la $a0, msg_found_sur
    syscall
    li $s0, 1                       # Attivazione flag matching
    
skip_sur_header:
    move $a0, $t0                   
    jal sub_print_student

next_sur_search:
    addi $t1, $t1, 1                # Incremento contatore ciclo
    addi $t0, $t0, STUDENT_SIZE     # Avanzamento del puntatore al blocco di memoria successivo
    j search_sur_loop

end_sur_search:
    beq $s0, 1, back_to_menu        
    li $v0, 4
    la $a0, msg_not_found
    syscall
back_to_menu:
    j menu_loop

# ==========================================
# 5. AGGIUNGI ESAME
# ==========================================
feat_5_add_exam:
    li $v0, 4
    la $a0, prompt_add_exam_id
    syscall
    li $v0, 5
    syscall
    move $a0, $v0 
    jal sub_find_student_by_id
    
    move $t0, $v0 
    beq $t0, $zero, feat_5_not_found

    lw $t5, OFF_EXAMS_N($t0)
    li $t6, MAX_EXAMS_LIMIT
    bge $t5, $t6, max_exams_error   # Controllo anti-overflow per numero di esami limitato

    li $t7, EXAM_SIZE
    mul $t8, $t5, $t7               # Calcolo offset del nuovo esame (num_esami_presenti * size)
    addi $t8, $t8, OFF_EXAMS_A      # Somma dell'offset dell'array all'interno del record studente
    add $t9, $t0, $t8               # Puntatore assoluto al blocco di memoria per il nuovo esame

    li $v0, 4
    la $a0, prompt_exam_name
    syscall
    li $v0, 8
    move $a0, $t9
    li $a1, MAX_STR_LEN  
    addi $a1, $a1, 1 
    syscall
    
    move $a0, $t9
    jal sub_remove_newline

read_cred_loop_f5:
    li $v0, 4
    la $a0, prompt_exam_cred
    syscall
    li $v0, 5
    syscall
    ble $v0, $zero, invalid_cred_f5
    sw $v0, EXAM_CREDITS($t9)      

read_grade_loop_f5:
    li $v0, 4
    la $a0, prompt_exam_grade
    syscall
    li $v0, 5
    syscall
    blt $v0, MIN_GRADE, invalid_grade_f5
    bgt $v0, MAX_GRADE, invalid_grade_f5
    sw $v0, EXAM_GRADE($t9)
    j grade_is_valid_f5

invalid_cred_f5:
    li $v0, 4
    la $a0, msg_invalid_cred
    syscall
    j read_cred_loop_f5            

invalid_grade_f5:
    li $v0, 4
    la $a0, msg_invalid_grade
    syscall
    j read_grade_loop_f5

grade_is_valid_f5:
    addi $t5, $t5, 1                # Incremento del contatore esami dello studente
    sw $t5, OFF_EXAMS_N($t0)

    li $v0, 4
    la $a0, msg_exam_added
    syscall
    j menu_loop

max_exams_error:
    li $v0, 4
    la $a0, msg_max_exams
    syscall
    j menu_loop

feat_5_not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j menu_loop
    
# ==========================================
# 6. MODIFICA INFO PERSONALI STUDENTE
# ==========================================
feat_6_edit_student:
    li $v0, 4
    la $a0, prompt_edit_id
    syscall
    li $v0, 5
    syscall
    move $a0, $v0
    jal sub_find_student_by_id
    
    move $t0, $v0 
    beq $t0, $zero, feat_6_not_found
    
    li $v0, 4
    la $a0, prompt_nome
    syscall
    li $v0, 8
    addi $a0, $t0, OFF_NAME
    li $a1, MAX_STR_LEN  
    addi $a1, $a1, 1 
    syscall
    addi $a0, $t0, OFF_NAME
    jal sub_remove_newline

    li $v0, 4
    la $a0, prompt_cognome
    syscall
    li $v0, 8
    addi $a0, $t0, OFF_SURNAME
    li $a1, MAX_STR_LEN  
    addi $a1, $a1, 1 
    syscall
    addi $a0, $t0, OFF_SURNAME
    jal sub_remove_newline

read_edit_age_loop:
    li $v0, 4
    la $a0, prompt_eta
    syscall
    li $v0, 5
    syscall
    blt $v0, MIN_AGE, invalid_edit_age
    bgt $v0, MAX_AGE, invalid_edit_age
    sw $v0, OFF_AGE($t0)
    j read_edit_year_loop

invalid_edit_age:
    li $v0, 4
    la $a0, msg_invalid_age
    syscall
    j read_edit_age_loop

read_edit_year_loop:
    li $v0, 4
    la $a0, prompt_anno
    syscall
    li $v0, 5
    syscall
    blt $v0, MIN_YEAR, invalid_edit_year
    bgt $v0, MAX_YEAR, invalid_edit_year
    sw $v0, OFF_YEAR($t0)
    j edit_success_end

invalid_edit_year:
    li $v0, 4
    la $a0, msg_invalid_year
    syscall
    j read_edit_year_loop

edit_success_end:
    li $v0, 4
    la $a0, msg_edit_success
    syscall
    j menu_loop

feat_6_not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j menu_loop

# ==========================================
# 7. CANCELLAZIONE LOGICA
# ==========================================
feat_7_delete_student:
    li $v0, 4
    la $a0, prompt_delete_id
    syscall
    li $v0, 5
    syscall
    move $a0, $v0
    jal sub_find_student_by_id
    
    move $t0, $v0
    beq $t0, $zero, feat_7_not_found
    
    sw $zero, OFF_STATUS($t0)       # Switch off: inibisce lo studente senza deallocare la memoria
    
    li $v0, 4
    la $a0, msg_delete_success
    syscall
    j menu_loop

feat_7_not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j menu_loop
    
# ==========================================
# 8. CALCOLA MEDIA
# ==========================================
feat_8_calc_gpa:
    li $v0, 4
    la $a0, prompt_gpa_id
    syscall
    li $v0, 5
    syscall
    move $a0, $v0
    jal sub_find_student_by_id
    
    move $t0, $v0
    beq $t0, $zero, feat_8_not_found
    
    move $a0, $t0  
    jal sub_calc_gpa                
    
    beq $v0, -1, feat_8_no_exams    # Controllo codice errore subroutine (esito -1 = nessun esame)
    
    mov.s $f12, $f0                 # Spostamento registro floating point per stampa Syscall 2
    li $v0, 4
    la $a0, msg_gpa_result
    syscall
    li $v0, 2
    syscall
    li $v0, 4
    la $a0, str_newline
    syscall
    j menu_loop

feat_8_not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j menu_loop

feat_8_no_exams:
    li $v0, 4
    la $a0, msg_no_exams
    syscall
    j menu_loop

# ==========================================
# 9. TROVA IL MIGLIOR STUDENTE (O I MIGLIORI IN CASO DI PAREGGIO)
# ==========================================
feat_9_best_student:
    la $t0, total_students_inserted
    lw $s1, 0($t0)                  
    beq $s1, 0, feat_9_no_best      

    li $s2, 0                       
    la $s3, student_db              
    
    li $t1, -1
    mtc1 $t1, $f20                  # Caricamento costante -1.0 nella FPU per ricerca massimo
    cvt.s.w $f20, $f20              

feat_9_find_max_loop:
    bge $s2, $s1, feat_9_start_print_loop   

    lw $t4, OFF_STATUS($s3)
    beq $t4, $zero, feat_9_find_max_next  # Salto iterazione se lo studente è logicamente inattivo

    move $a0, $s3                   
    jal sub_calc_gpa                
    
    beq $v0, -1, feat_9_find_max_next 
    
    c.lt.s $f20, $f0                # Confronto floating-point per aggiornamento massimo assoluto
    bc1f feat_9_find_max_next       # Branch condizionale FPU: salta se test fallisce
    
    mov.s $f20, $f0                 

feat_9_find_max_next:
    addi $s2, $s2, 1                # Incremento contatore ciclo
    addi $s3, $s3, STUDENT_SIZE     # Avanzamento del puntatore al blocco di memoria successivo
    j feat_9_find_max_loop

feat_9_start_print_loop:
    li $t1, -1
    mtc1 $t1, $f4
    cvt.s.w $f4, $f4
    
    c.eq.s $f20, $f4                # Controllo anti-stallo: se record uguale a -1.0 nessun esame calcolabile
    bc1t feat_9_no_best             

    li $v0, 4
    la $a0, msg_best_student
    syscall
    
    mov.s $f12, $f20                
    li $v0, 2                       
    syscall
    
    li $v0, 4
    la $a0, msg_best_list           
    syscall

    li $s2, 0                       
    la $s3, student_db              

feat_9_print_loop:
    bge $s2, $s1, feat_9_end        

    lw $t4, OFF_STATUS($s3)
    beq $t4, $zero, feat_9_print_next  # Salto iterazione se lo studente è logicamente inattivo

    move $a0, $s3                   
    jal sub_calc_gpa                
    
    beq $v0, -1, feat_9_print_next  
    
    c.eq.s $f0, $f20                # Match floating-point: verifica se la media eguaglia il record
    bc1f feat_9_print_next          

    move $a0, $s3                   
    jal sub_print_student

feat_9_print_next:
    addi $s2, $s2, 1
    addi $s3, $s3, STUDENT_SIZE
    j feat_9_print_loop

feat_9_end:
    j menu_loop

feat_9_no_best:
    li $v0, 4
    la $a0, msg_no_best
    syscall
    j menu_loop
        
# ==========================================
# 10. CALCOLA TOTALE CREDITI
# ==========================================
feat_10_tot_credits:
    li $v0, 4
    la $a0, prompt_cred_id
    syscall
    li $v0, 5
    syscall
    
    move $a0, $v0                   
    jal sub_find_student_by_id
    move $t0, $v0                   
    beq $t0, $zero, feat_10_not_found   

    move $a0, $t0                   
    jal sub_calc_credits
    
    move $t1, $v0                   
    
    li $v0, 4
    la $a0, msg_tot_credits
    syscall
    
    li $v0, 1                       
    move $a0, $t1                   
    syscall
    
    li $v0, 4
    la $a0, str_newline
    syscall
    j menu_loop

feat_10_not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j menu_loop        
        
# ==========================================
# 11. STAMPA STUDENTI SOPRA SOGLIA
# ==========================================
feat_11_threshold:
    la $t0, total_students_inserted
    lw $s1, 0($t0)                  
    beq $s1, $zero, feat_11_empty       

    li $v0, 4
    la $a0, prompt_threshold
    syscall
    
    li $v0, 6                       
    syscall                         
    
    mov.s $f20, $f0                 # Trasferimento della soglia floating-point in registro preservato

    li $s2, 0                       
    la $s3, student_db              
    li $s5, 0                       # Flag per gestire il fallimento selettivo dell'interrogazione
    
    li $v0, 4
    la $a0, msg_above_threshold
    syscall

feat_11_loop:
    bge $s2, $s1, feat_11_end       

    lw $t4, OFF_STATUS($s3)
    beq $t4, $zero, feat_11_next    # Salto iterazione se lo studente è logicamente inattivo

    move $a0, $s3                   
    jal sub_calc_gpa                
    
    beq $v0, -1, feat_11_next       
    
    c.lt.s $f0, $f20                # Criterio inverso: escludi se Media < Soglia target
    bc1t feat_11_next               

    li $s5, 1                       
                  
    move $a0, $s3                   
    jal sub_print_student
    
    li $v0, 4
    la $a0, msg_gpa_result
    syscall
      
    li $v0, 2                       
    mov.s $f12, $f0                 
    syscall
    
    li $v0, 4
    la $a0, str_newline
    syscall
    syscall                         

feat_11_next:
    addi $s2, $s2, 1                # Incremento contatore ciclo
    addi $s3, $s3, STUDENT_SIZE     # Avanzamento del puntatore al blocco di memoria successivo
    j feat_11_loop

feat_11_end:
    beq $s5, 1, feat_11_exit        
    
    li $v0, 4
    la $a0, msg_none_above
    syscall

feat_11_exit:
    j menu_loop

feat_11_empty:
    li $v0, 4
    la $a0, str_empty_db
    syscall
    j menu_loop        
        
# ==========================================
# 12. STAMPA STUDENTI CON ALMENO N ESAMI
# ==========================================
feat_12_exams_threshold:
    la $t0, total_students_inserted
    lw $s1, 0($t0)                  
    beq $s1, $zero, feat_12_empty       

    li $v0, 4
    la $a0, prompt_exams_threshold
    syscall
    
    li $v0, 5                       
    syscall                         
    move $s6, $v0                   # Salvataggio soglia intera per match

    li $s2, 0                       
    la $s3, student_db              
    li $s5, 0                       # Flag per gestire il fallimento selettivo dell'interrogazione
    
    li $v0, 4
    la $a0, msg_above_exams
    syscall

feat_12_loop:
    bge $s2, $s1, feat_12_end       

    lw $t4, OFF_STATUS($s3)
    beq $t4, $zero, feat_12_next    # Salto iterazione se lo studente è logicamente inattivo

    lw $t5, OFF_EXAMS_N($s3)        
    
    blt $t5, $s6, feat_12_next      # Criterio di scarto per il mismatch di quantità

    li $s5, 1                       
    
    move $a0, $s3                   
    jal sub_print_student
    
    li $v0, 4
    la $a0, str_newline
    syscall                         

feat_12_next:
    addi $s2, $s2, 1                # Incremento contatore ciclo
    addi $s3, $s3, STUDENT_SIZE     # Avanzamento del puntatore al blocco di memoria successivo
    j feat_12_loop

feat_12_end:
    beq $s5, 1, feat_12_exit        
    
    li $v0, 4
    la $a0, msg_none_above          
    syscall

feat_12_exit:
    j menu_loop

feat_12_empty:
    li $v0, 4
    la $a0, str_empty_db
    syscall
    j menu_loop        
        
# ==========================================
# 13. ORDINA STUDENTI PER ID (Bubble Sort)
# ==========================================
feat_13_sort_id:
    la $t0, total_students_inserted
    lw $s1, 0($t0)                  
    
    li $t1, 2
    blt $s1, $t1, feat_13_end_sort  # Fallback: un DB con 0 o 1 elemento è già considerato ordinato

    li $s2, 0                       
    subi $s7, $s1, 1                # Calcolo limite teorico per il ciclo Bubble Sort esterno (N - 1)

outer_loop_f13:
    bge $s2, $s7, feat_13_end_sort  

    li $s3, 0                       
    sub $s4, $s7, $s2               # Ottimizzazione Bubble Sort: diminuzione perimetro di ricerca iterativa interno

    la $s5, student_db              # Assegnazione puntatore per blocco in comparazione (Indice J)
    addi $s6, $s5, STUDENT_SIZE     # Assegnazione puntatore per blocco adiacente (Indice J+1)

inner_loop_f13:
    bge $s3, $s4, next_outer_f13    

    lw $t4, OFF_ID($s5)             
    lw $t5, OFF_ID($s6)             

    ble $t4, $t5, no_swap_f13       # Branch condizionale: bypass se l'ordine strutturale è rispettato
    
    move $a0, $s5                   
    move $a1, $s6                   
    jal sub_swap_students           

no_swap_f13:
    addi $s5, $s5, STUDENT_SIZE     # Avanzamento base cursore J
    addi $s6, $s6, STUDENT_SIZE     # Avanzamento base cursore J+1
    addi $s3, $s3, 1                
    j inner_loop_f13

next_outer_f13:
    addi $s2, $s2, 1                
    j outer_loop_f13

feat_13_end_sort:
    li $v0, 4
    la $a0, msg_sort_success
    syscall
    j menu_loop        
        
# ==========================================
# 14. ORDINA STUDENTI PER MEDIA (Decrescente)
# ==========================================
feat_14_sort_gpa:
    la $t0, total_students_inserted
    lw $s1, 0($t0)                  
    
    li $t1, 2
    blt $s1, $t1, feat_14_end       # Fallback: un DB con 0 o 1 elemento è già considerato ordinato

    li $s2, 0                       
    subi $s7, $s1, 1                # Calcolo limite teorico per il ciclo Bubble Sort esterno (N - 1)

outer_loop_f14:
    bge $s2, $s7, feat_14_end       

    li $s3, 0                       
    sub $s4, $s7, $s2               # Ottimizzazione Bubble Sort: diminuzione perimetro di ricerca iterativa interno

    la $s5, student_db              # Assegnazione puntatore per blocco in comparazione (Indice J)
    addi $s6, $s5, STUDENT_SIZE     # Assegnazione puntatore per blocco adiacente (Indice J+1)

inner_loop_f14:
    bge $s3, $s4, next_outer_f14    

    move $a0, $s5                   
    jal sub_calc_gpa                
    
    mov.s $f20, $f0                 # Isolamento temporaneo del calcolo GPA dello studente J su registro FPU sicuro

    move $a0, $s6                   
    jal sub_calc_gpa                

    c.lt.s $f20, $f0                # Verifica inversione GPA: attiva se J+1 ha media maggiore di J
    
    bc1f no_swap_f14                # Branch FPU: bypass scambio se l'ordine decrescente è soddisfatto

    move $a0, $s5                   
    move $a1, $s6                   
    jal sub_swap_students           

no_swap_f14:
    addi $s5, $s5, STUDENT_SIZE     # Avanzamento base cursore J
    addi $s6, $s6, STUDENT_SIZE     # Avanzamento base cursore J+1
    addi $s3, $s3, 1                
    j inner_loop_f14

next_outer_f14:
    addi $s2, $s2, 1                
    j outer_loop_f14

feat_14_end:
    li $v0, 4
    la $a0, msg_sort_success
    syscall
    j menu_loop        
        
# ==========================================
# 15. STAMPA STATISTICHE GLOBALI
# ==========================================
feat_15_stats:
    la $t0, total_students_inserted
    lw $s1, 0($t0)                  
    beq $s1, $zero, feat_15_empty

    li $s2, 0                       
    la $s3, student_db              
    
    li $s4, 0                       # Accumulatore conteggio studenti attivi
    li $s5, 0                       # Accumulatore totale esami verbalizzati
    li $s6, 0                       # Divisore valido per la media ponderata globale (studenti con esami)
    li $s7, 0                       # Accumulatore età totale per età media
    
    mtc1 $zero, $f20                # Somma delle medie pesate (0.0 iniziale)

feat_15_loop:
    bge $s2, $s1, feat_15_print     

    lw $t4, OFF_STATUS($s3)
    beq $t4, $zero, feat_15_next        # Salto iterazione se lo studente è logicamente inattivo

    addi $s4, $s4, 1                # Incremento contatore attivi
    
    lw $t5, OFF_AGE($s3)
    add $s7, $s7, $t5               # Somma l'età per calcolo media anagrafica

    lw $t5, OFF_EXAMS_N($s3)
    add $s5, $s5, $t5               # Somma il numero di esami passati

    move $a0, $s3                   
    jal sub_calc_gpa                
    
    beq $v0, -1, feat_15_next       # Scarto dati: lo studente non ha esami validi per concorrere alla media globale

    addi $s6, $s6, 1                # Aggiornamento parziale per denominatore globale valido
    add.s $f20, $f20, $f0           # Somma additiva delle medie in floating-point

feat_15_next:
    addi $s2, $s2, 1
    addi $s3, $s3, STUDENT_SIZE
    j feat_15_loop

feat_15_print:
    li $v0, 4
    la $a0, msg_stat_title
    syscall

    # a. Stampa Totale Studenti Attivi
    la $a0, msg_stat_tot
    syscall
    li $v0, 1
    move $a0, $s4
    syscall
    li $v0, 4
    la $a0, str_newline
    syscall

    beq $s4, $zero, feat_15_no_avg  # Se zero attivi, evita divisioni anomale

    # b. Calcolo e Stampa Età Media (Richiesto dal Prof.)
    mtc1 $s7, $f4                   
    cvt.s.w $f4, $f4                # Casting età totale a float
    mtc1 $s4, $f6                   
    cvt.s.w $f6, $f6                # Casting studenti attivi a float
    div.s $f12, $f4, $f6            # FPU division
    
    li $v0, 4
    la $a0, msg_stat_age
    syscall
    li $v0, 2                       # Stampa Float
    syscall
    li $v0, 4
    la $a0, str_newline
    syscall

    # c. Calcolo e Stampa Media Esami per Studente (Richiesto dal Prof.)
    mtc1 $s5, $f4                   
    cvt.s.w $f4, $f4                # Casting totale esami a float
    div.s $f12, $f4, $f6            # Divisione per numero studenti attivi ($f6)
    
    li $v0, 4
    la $a0, msg_stat_exams_avg
    syscall
    li $v0, 2                       # Stampa Float
    syscall
    li $v0, 4
    la $a0, str_newline
    syscall

    # d. Calcolo e Stampa Media Ponderata Globale
    beq $s6, $zero, feat_15_no_avg      

    mtc1 $s6, $f4                   
    cvt.s.w $f4, $f4                # Casting denominatore studenti con voti
    div.s $f12, $f20, $f4           # Computazione finale

    li $v0, 4
    la $a0, msg_stat_avg
    syscall
    li $v0, 2                       
    syscall
    li $v0, 4
    la $a0, str_newline
    syscall

    j menu_loop

feat_15_no_avg:
    li $v0, 4
    la $a0, msg_stat_no_avg
    syscall
    j menu_loop

feat_15_empty:
    li $v0, 4
    la $a0, str_empty_db
    syscall
    j menu_loop
    
# ==========================================
# 16. ESPORTA REPORT COMPATTO (CSV)
# ==========================================
feat_16_report:
    la $t0, total_students_inserted
    lw $s1, 0($t0)                  
    beq $s1, $zero, feat_16_empty

    li $v0, 4
    la $a0, msg_report_title
    syscall

    li $s2, 0                       
    la $s3, student_db              

feat_16_loop:
    bge $s2, $s1, feat_16_end       

    lw $t4, OFF_STATUS($s3)
    beq $t4, $zero, feat_16_next    # Salto iterazione se lo studente è logicamente inattivo

    li $v0, 1
    lw $a0, OFF_ID($s3)
    syscall
    li $v0, 4
    la $a0, str_comma
    syscall

    li $v0, 4
    addi $a0, $s3, OFF_NAME
    syscall
    li $v0, 4
    la $a0, str_comma
    syscall

    li $v0, 4
    addi $a0, $s3, OFF_SURNAME
    syscall
    li $v0, 4
    la $a0, str_comma
    syscall

    li $v0, 1
    lw $a0, OFF_AGE($s3)
    syscall
    li $v0, 4
    la $a0, str_comma
    syscall

    li $v0, 1
    lw $a0, OFF_YEAR($s3)
    syscall
    li $v0, 4
    la $a0, str_comma
    syscall

    li $v0, 1
    lw $a0, OFF_EXAMS_N($s3)
    syscall
    
    li $v0, 4
    la $a0, str_newline
    syscall

feat_16_next:
    addi $s2, $s2, 1                # Incremento contatore ciclo
    addi $s3, $s3, STUDENT_SIZE     # Avanzamento del puntatore al blocco di memoria successivo
    j feat_16_loop

feat_16_end:
    li $v0, 4
    la $a0, str_newline
    syscall
    j menu_loop

feat_16_empty:
    li $v0, 4
    la $a0, str_empty_db
    syscall
    j menu_loop
          
# ==========================================
# 17. STAMPA RICORSIVA ESAMI (Ordine inverso)
# ==========================================
feat_17_recursive:
    li $v0, 4
    la $a0, prompt_rec_id
    syscall
    li $v0, 5
    syscall
    move $a0, $v0                   
    jal sub_find_student_by_id

    move $s0, $v0                   
    beq $s0, $zero, feat_17_not_found

    lw $a1, OFF_EXAMS_N($s0)        # Preparazione dell'argomento depth limit della ricorsione
    beq $a1, $zero, feat_17_no_exams

    li $v0, 4
    la $a0, msg_rec_title
    syscall

    addi $a0, $s0, OFF_EXAMS_A      # Spostamento registro parametrico: indirizzo al primo blocco esame
    
    jal sub_recursive_print_exams

    li $v0, 4
    la $a0, str_newline
    syscall
    j menu_loop

feat_17_no_exams:
    li $v0, 4
    la $a0, msg_no_exams
    syscall
    j menu_loop

feat_17_not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j menu_loop
             
# =================================================================
# SUBROUTINE: sub_copy_string
# Descrizione: Copia stringa (max $a2 caratteri). Rispetta la MIPS Calling Convention.
# Input:       $a0 = Indirizzo stringa sorgente
#              $a1 = Indirizzo di destinazione
#              $a2 = Limite massimo di caratteri
# Output:      Nessuno. Memoria aggiornata.
# =================================================================
sub_copy_string:
    addi $sp, $sp, -8            # Allocazione frame d'attivazione sullo stack
    sw $s0, 0($sp)               # Preservazione registro locale
    sw $s1, 4($sp)               # Preservazione registro locale

    li $s0, 0                    
    
sub_copy_loop:
    lb $s1, 0($a0)               # Accesso incrementale al byte della stringa base
    sb $s1, 0($a1)               # Assegnazione in-place del byte sulla memoria target
    
    beq $s1, $zero, sub_copy_end # Terminazione precoce per raggiungimento di string terminator
    beq $s0, $a2, sub_copy_end   # Terminazione di sicurezza per capacity limit
    
    addi $a0, $a0, 1             # Incremento puntatore cursore sorgente
    addi $a1, $a1, 1             # Incremento puntatore cursore target
    addi $s0, $s0, 1             # Incremento indicatore posizionale
    j sub_copy_loop
    
sub_copy_end:
    sb $zero, 0($a1)             # Iniezione forzata del terminatore finale per string array
    
    lw $s0, 0($sp)               # Ripristino registro locale pre-chiamata
    lw $s1, 4($sp)               # Ripristino registro locale pre-chiamata
    addi $sp, $sp, 8             # Deallocazione frame e chiusura stack
    
    jr $ra                       # Ritorno al main program flow      
            
# =================================================================
# SUBROUTINE: sub_remove_newline
# Descrizione: Scorre una stringa in-place e sostituisce il primo carattere '\n' con '\0'.
# Input:       $a0 = Indirizzo base della stringa da pulire
# Output:      Nessuno. Memoria (stringa) aggiornata.
# =================================================================
sub_remove_newline:
    addi $sp, $sp, -8               # Allocazione frame d'attivazione sullo stack
    sw $s0, 0($sp)                  # Preservazione registro locale
    sw $s1, 4($sp)                  # Preservazione registro locale

    move $s0, $a0                   
srn_loop:
    lb $s1, 0($s0)                  
    beq $s1, $zero, srn_end         # Risoluzione prematura in assenza di newline
    beq $s1, 10, srn_replace        # Match esatto per Line Feed in tabella ASCII
    addi $s0, $s0, 1                
    j srn_loop
srn_replace:
    sb $zero, 0($s0)                # Sovrascrittura silente in-place del buffer

srn_end:
    lw $s0, 0($sp)                  # Ripristino registro locale pre-chiamata
    lw $s1, 4($sp)                  # Ripristino registro locale pre-chiamata
    addi $sp, $sp, 8                # Deallocazione frame e chiusura stack
    jr $ra                          

# =================================================================
# SUBROUTINE: sub_find_student_by_id
# Descrizione: Cerca uno studente nel DB confrontando l'ID. Salta gli studenti inattivi (Status=0).
# Input:       $a0 = ID dello studente da cercare
# Output:      $v0 = Indirizzo base dello studente (0 se non trovato)
# =================================================================
sub_find_student_by_id:
    addi $sp, $sp, -16              # Allocazione frame d'attivazione sullo stack
    sw $s0, 0($sp)                  # Preservazione registro locale
    sw $s1, 4($sp)                  # Preservazione registro locale
    sw $s2, 8($sp)                  # Preservazione registro locale
    sw $s3, 12($sp)                 # Preservazione registro locale

    la $s0, student_db
    li $s1, 0
    la $s2, total_students_inserted
    lw $s2, 0($s2)

sub_search_loop:
    bge $s1, $s2, sub_not_found  
    lw $s3, OFF_STATUS($s0)  
    beq $s3, $zero, sub_next_student  # Salto iterazione se lo studente è logicamente inattivo
    
    lw $s3, OFF_ID($s0)  
    beq $s3, $a0, sub_found  
    
sub_next_student:
    addi $s1, $s1, 1
    addi $s0, $s0, STUDENT_SIZE     # Avanzamento dinamico di passo memoria a step modulari
    j sub_search_loop

sub_found:
    move $v0, $s0                   # Allocazione esito risolto
    j sub_find_end
sub_not_found:
    move $v0, $zero                 # Esito fallimentare (0x0)

sub_find_end:
    lw $s0, 0($sp)                  # Ripristino registro locale pre-chiamata
    lw $s1, 4($sp)                  # Ripristino registro locale pre-chiamata
    lw $s2, 8($sp)                  # Ripristino registro locale pre-chiamata
    lw $s3, 12($sp)                 # Ripristino registro locale pre-chiamata
    addi $sp, $sp, 16               # Deallocazione frame e chiusura stack
    jr $ra

# =================================================================
# SUBROUTINE: sub_calc_gpa
# Descrizione: Calcola la media ponderata usando il coprocessore matematico (FPU).
# Input:       $a0 = Indirizzo base dello studente nel DB
# Output:      $f0 = Media ponderata (Floating Point Single Precision)
#              $v0 = Stato dell'operazione (0 = Successo, -1 = Errore/Nessun esame)
# =================================================================
sub_calc_gpa:
    addi $sp, $sp, -28              # Allocazione frame d'attivazione esteso sullo stack
    sw $s0, 0($sp)                  # Preservazione registro locale
    sw $s1, 4($sp)                  # Preservazione registro locale
    sw $s2, 8($sp)                  # Preservazione registro locale
    sw $s3, 12($sp)                 # Preservazione registro locale
    sw $s4, 16($sp)                 # Preservazione registro locale
    sw $s5, 20($sp)                 # Preservazione registro locale
    sw $s6, 24($sp)                 # Preservazione registro locale

    lw $s0, OFF_EXAMS_N($a0)        
    bne $s0, $zero, sub_gpa_proceed  
    
    mtc1 $zero, $f0                 # Azzeramento d'uscita floating point per sanificazione
    li $v0, -1                      # Codice arbitrario di uscita anomala
    j sub_gpa_end

sub_gpa_proceed:
    li $s1, 0  
    addi $s2, $a0, OFF_EXAMS_A      # Traslazione puntatore all'head dell'array Esami per lo studente
    li $s3, 0  
    li $s4, 0  

sub_gpa_loop:
    bge $s1, $s0, sub_gpa_div  
    
    lw $s5, EXAM_CREDITS($s2)   
    lw $s6, EXAM_GRADE($s2)         
    
    mul $s6, $s6, $s5               # Ottenimento risultato pre-calcolato (Voto * Crediti)
    
    add $s3, $s3, $s6               # Accumulo progressivo per il numeratore algebrico
    add $s4, $s4, $s5               # Accumulo progressivo per il denominatore algebrico
    
    addi $s1, $s1, 1  
    addi $s2, $s2, EXAM_SIZE        # Avanzamento del puntatore al blocco esame contiguo
    j sub_gpa_loop                  

sub_gpa_div:
    mtc1 $s3, $f4  
    mtc1 $s4, $f6                   # Elevazione dei registri MIPS allo strato del coprocessore aritmetico
    cvt.s.w $f4, $f4  
    cvt.s.w $f6, $f6                # Conversione implicita word-to-single per compliance della divisione
    div.s $f0, $f4, $f6  
    move $v0, $zero  

sub_gpa_end:
    lw $s0, 0($sp)                  # Ripristino registro locale pre-chiamata
    lw $s1, 4($sp)                  # Ripristino registro locale pre-chiamata
    lw $s2, 8($sp)                  # Ripristino registro locale pre-chiamata
    lw $s3, 12($sp)                 # Ripristino registro locale pre-chiamata
    lw $s4, 16($sp)                 # Ripristino registro locale pre-chiamata
    lw $s5, 20($sp)                 # Ripristino registro locale pre-chiamata
    lw $s6, 24($sp)                 # Ripristino registro locale pre-chiamata
    addi $sp, $sp, 28               # Deallocazione frame e chiusura stack
    jr $ra

# =================================================================
# SUBROUTINE: sub_print_student
# Descrizione: Stampa a schermo tutti i dati anagrafici e contatori dello studente.
# Input:       $a0 = Indirizzo base dello studente nel DB
# Output:      Nessuno. Output su console tramite Syscall.
# =================================================================
sub_print_student:
    addi $sp, $sp, -4               # Allocazione frame d'attivazione sullo stack
    sw $s0, 0($sp)                  # Preservazione registro locale
    
    move $s0, $a0                   

    li $v0, 4
    la $a0, str_id
    syscall
    li $v0, 1
    lw $a0, OFF_ID($s0)
    syscall
    
    li $v0, 4
    la $a0, str_nome
    syscall
    li $v0, 4
    addi $a0, $s0, OFF_NAME
    syscall
    
    li $v0, 4
    la $a0, str_cognome
    syscall
    li $v0, 4
    addi $a0, $s0, OFF_SURNAME
    syscall
    
    li $v0, 4
    la $a0, str_eta
    syscall
    li $v0, 1
    lw $a0, OFF_AGE($s0)
    syscall
    
    li $v0, 4
    la $a0, str_anno
    syscall
    li $v0, 1
    lw $a0, OFF_YEAR($s0)
    syscall
    
    li $v0, 4
    la $a0, str_esami
    syscall
    li $v0, 1
    lw $a0, OFF_EXAMS_N($s0)
    syscall
    
    li $v0, 4
    la $a0, str_newline
    syscall
    
    lw $s0, 0($sp)                  # Ripristino registro locale pre-chiamata
    addi $sp, $sp, 4                # Deallocazione frame e chiusura stack
    jr $ra

# =================================================================
# SUBROUTINE: sub_calc_credits
# Descrizione: Itera sugli esami di uno studente e somma i crediti ottenuti.
# Input:       $a0 = Indirizzo base dello studente nel DB
# Output:      $v0 = Somma totale dei crediti (0 se nessuno)
# =================================================================
sub_calc_credits:
    addi $sp, $sp, -16              # Allocazione frame d'attivazione sullo stack
    sw $s0, 0($sp)                  # Preservazione registro locale
    sw $s1, 4($sp)                  # Preservazione registro locale
    sw $s2, 8($sp)                  # Preservazione registro locale
    sw $s3, 12($sp)                 # Preservazione registro locale

    lw $s0, OFF_EXAMS_N($a0)        
    move $v0, $zero                 
    
    beq $s0, $zero, sub_cred_end    

    li $s1, 0                       
    addi $s2, $a0, OFF_EXAMS_A      # Traslazione puntatore all'head dell'array Esami per lo studente

sub_cred_loop:
    beq $s1, $s0, sub_cred_end  
    
    lw $s3, EXAM_CREDITS($s2)       
    add $v0, $v0, $s3               # Somma diretta del blocco crediti all'output calcolato
    
    addi $s1, $s1, 1                
    addi $s2, $s2, EXAM_SIZE        # Avanzamento del puntatore al blocco esame contiguo
    j sub_cred_loop

sub_cred_end:
    lw $s0, 0($sp)                  # Ripristino registro locale pre-chiamata
    lw $s1, 4($sp)                  # Ripristino registro locale pre-chiamata
    lw $s2, 8($sp)                  # Ripristino registro locale pre-chiamata
    lw $s3, 12($sp)                 # Ripristino registro locale pre-chiamata
    addi $sp, $sp, 16               # Deallocazione frame e chiusura stack
    jr $ra

# =================================================================
# SUBROUTINE: sub_swap_students
# Descrizione: Scambia fisicamente in memoria le struct di due studenti (copia word per word).
# Input:       $a0 = Indirizzo base del primo studente (Studente A)
#              $a1 = Indirizzo base del secondo studente (Studente B)
# Output:      Nessuno. Memoria RAM invertita tra i due blocchi.
# =================================================================
sub_swap_students:
    addi $sp, $sp, -20              # Allocazione frame d'attivazione esteso sullo stack
    sw $s0, 0($sp)                  # Preservazione registro locale (Iterazioni word)
    sw $s1, 4($sp)                  # Preservazione registro locale (Puntatore A dinamico)
    sw $s2, 8($sp)                  # Preservazione registro locale (Puntatore B dinamico)
    sw $s3, 12($sp)                 # Preservazione registro locale (Cache copia)
    sw $s4, 16($sp)                 # Preservazione registro locale (Cache copia)

    li $s0, STUDENT_SIZE            
    
    srl $s0, $s0, 2                 # Divisione per 4 tramite shift logico per dedurre il count esatto di Words
    
    move $s1, $a0                   
    move $s2, $a1                   

swap_loop:
    ble $s0, $zero, swap_end        
    
    lw $s3, 0($s1)                  # Estrazione pacchetto dati da 4 byte dal blocco allocato A
    lw $s4, 0($s2)                  # Estrazione pacchetto dati da 4 byte dal blocco allocato B
    
    sw $s4, 0($s1)                  # Swap and inject del pacchetto word B sulla RAM del cluster A
    sw $s3, 0($s2)                  # Swap and inject del pacchetto word A sulla RAM del cluster B
    
    addi $s1, $s1, 4                # Avanzamento offset strutturale Word
    addi $s2, $s2, 4                # Avanzamento offset strutturale Word
    
    subi $s0, $s0, 1                # Decremento del residuo interazioni
    j swap_loop                     

swap_end:
    lw $s0, 0($sp)                  # Ripristino registro locale pre-chiamata
    lw $s1, 4($sp)                  # Ripristino registro locale pre-chiamata
    lw $s2, 8($sp)                  # Ripristino registro locale pre-chiamata
    lw $s3, 12($sp)                 # Ripristino registro locale pre-chiamata
    lw $s4, 16($sp)                 # Ripristino registro locale pre-chiamata
    addi $sp, $sp, 20               # Deallocazione frame e chiusura stack
    
    jr $ra                 
    
# =================================================================
# SUBROUTINE: sub_toupper
# Descrizione: Converte un singolo carattere ASCII da minuscolo a maiuscolo
#              utilizzando il mascheramento bit a bit (Bitwise AND).
# Input:       $a0 = Carattere ASCII da convertire
# Output:      $v0 = Carattere convertito (o invariato se non minuscolo)
# =================================================================
sub_toupper:
    move $v0, $a0                   # Copia preventivamente l'input nel registro di output
    
    blt $v0, ASCII_MIN_LOWER, end_toupper        # Se il codice è < 'a' (97), salta (non è una minuscola)
    bgt $v0, ASCII_MAX_LOWER, end_toupper       # Se il codice è > 'z' (122), salta (non è una minuscola)
    
    # --- MASCHERAMENTO BITWISE ---
    # Applica l'AND logico con la maschera 0xDF (1101 1111 in binario).
    # Questo lascia inalterati tutti i bit tranne il 5° (che vale 32), 
    # forzandolo a 0 e trasformando la lettera in maiuscola.
    andi $v0, $v0, 0xDF             
    
end_toupper:
    jr $ra                          # Ritorna alla funzione chiamante       
    
# =================================================================
# SUBROUTINE RICORSIVA: sub_recursive_print_exams
# Descrizione: Stampa gli esami in ordine inverso rispetto all'inserimento, sfruttando lo stack (emersione).
# Input:       $a0 = Puntatore all'esame corrente
#              $a1 = Numero di esami rimanenti
# Output:      Nessuno. Output su console tramite Syscall.
# =================================================================
sub_recursive_print_exams:
    ble $a1, $zero, rec_base_case   # Condizione base di break per depth limit di ricorsione

    addi $sp, $sp, -8               # Allocazione protetta stack pointer (Return address tracking)
    sw $ra, 0($sp)                  # Isolamento prioritario Return Address essenziale all'emersione
    sw $s0, 4($sp)                  # Isolamento puntatore dello statement chiamante

    move $s0, $a0                   

    addi $a0, $a0, EXAM_SIZE        # Avvolgimento progressivo parametrico per chiamata level-down
    subi $a1, $a1, 1                # Decadimento parametrico limite iterativo

    jal sub_recursive_print_exams   # Chiamata ricorsiva (Immersione nel memory block)

    # --- Fase di Emersione e Stampa Risoluta ---
    # Lo stato in $s0 è garantito da ripristino per via della segmentazione a cascata
    
    li $v0, 4
    move $a0, $s0                   
    syscall

    li $v0, 4
    la $a0, str_cred_rec
    syscall
    li $v0, 1
    lw $a0, EXAM_CREDITS($s0)
    syscall

    li $v0, 4
    la $a0, str_voto_rec
    syscall
    li $v0, 1
    lw $a0, EXAM_GRADE($s0)
    syscall

    li $v0, 4
    la $a0, str_newline
    syscall

    lw $ra, 0($sp)                  # Emersione Return Address dell'ambito superiore
    lw $s0, 4($sp)                  # Emersione Local Register dell'ambito superiore
    addi $sp, $sp, 8                # Deallocazione istanza frammentata
    
rec_base_case:
    jr $ra
    
# ==========================================
# GESTIONE ERRORI ED USCITA
# ==========================================
not_implemented:
    li $v0, 4
    la $a0, msg_not_impl
    syscall
    j menu_loop

exit_program:
    li $v0, 4
    la $a0, msg_exit
    syscall
    li $v0, 10
    syscall
