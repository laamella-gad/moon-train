
init_irq        .macro irq_handler, raster_line
                SEI
                LDA #%01111111  ; "Switch off" interrupts signals from CIA-1
                STA CIA1_ICR
                AND VIC_CTRL1       ; Clear most significant bit in VIC's raster register
                STA VIC_CTRL1

                LDA #\raster_line    ; Set the raster line number where interrupt should occur
                STA VIC_HLINE

                LDA #<_irq_handler       ; Set the interrupt vector to point to interrupt service routine below
                STA IRQVec
                LDA #>_irq_handler
                STA IRQVec+1
                LDA #%00000001  ; Enable raster interrupt signals from VIC
                STA VIC_IMR
                CLI
                jmp _done

_irq_handler    jsr \irq_handler
				ASL $D019	        ; "Acknowledge" the interrupt by clearing the VIC's interrupt flag.
				pla                 ; we exit interrupt entirely.
				tay
				pla
				tax
				pla
				rti                 ; end
_done
                .endm