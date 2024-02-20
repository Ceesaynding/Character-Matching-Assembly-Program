include emu8086.inc                         
org 100h

    main_loop:                              
        PRINT 'ENTER THE INPUT:'     
        mov temp[0],0                           
        mov temp[1],0                        
        mov temp[2],0                       
        mov temp[4],16H                     
                                            
        mov di,5                            
        mov si,0

    take_input:                            
        mov ah ,01h                         
        int 21h                            
        mov ah,0h                           
        mov word[si], ax                    
        inc si                              
                                            
        cmp al,13                            
        je print_matches                    
                                            
        jmp is_match                        
                                            

    is_match:             
        cmp al,5ah                          
        jg out_of_bounds                    
        cmp al,41h                          
        jl out_of_bounds                        
        
        mov bx,0                            
                             
                                            
            match_loop:                     
                cmp al, alphabet[bx]          
                je index_control            
                inc temp[1]                  
                inc bx                      
                jne match_loop             
     
     
        index_control:
            cmp temp[0], bl             
            je save_letter          
            inc temp[0]             
            jne take_input          

        out_of_bounds:                
            inc temp[0]             
            jmp take_input         

        save_letter:               
            mov temp[di],al        
            inc di                
            inc temp[0]           
            inc temp[2]           
            jmp take_input         


        print_matches:           
            jmp is_terminate
            not_terminate:
            cmp temp[2],0           
            jz print_zero_match     
            mov bl,temp[4]         
            add bl,temp[0]          
            add bl,2                
            mov al,temp[3]      
            GOTOXY bl,AL            
            PRINT ">"           
            mov ch,0h            
            mov cl,temp[2]         
            mov di,5               
        print_loop:             
            mov al, temp[di]        
            PUTC al              
            inc di                  
            loop print_loop       
            PRINT ">"            
            mov ah,0               
            mov al,temp[2]         
            CALL print_num        
            inc temp[3]             
            mov al,temp[3]       
            GOTOXY 0,AL        
            jmp main_loop          

        print_zero_match:         
            mov bl,temp[4]         
            add bl,temp[0]         
            add bl,2              
            mov al,temp[3]         
            GOTOXY bl,AL         
            PRINT ">"              
            PRINT "0"            
            inc temp[3]           
            mov al,temp[3]         
            GOTOXY 0,AL            
            jmp main_loop           


        is_terminate:                   
                mov cx,9
                lea si, stop
                  jmp terminate                     

        terminate:                                           
        ret


DEFINE_PRINT_NUM                            
DEFINE_PRINT_NUM_UNS                       

alphabet  db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
word  db 100 dup(0)
temp db 100 dup(0)                
stop db 'TERMINATE'       