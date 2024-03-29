import { FlashCard } from './FlashCard';

export class StudyList{
  
  flashcards:Array<FlashCard>
  flashcardReadToday:number
  flashcardToday:number

  constructor(flashcards:Array<FlashCard>,
  flashcardReadToday:number,
  flashcardToday:number) {
    this.flashcards = flashcards
    this.flashcardReadToday = flashcardReadToday
    this.flashcardToday = flashcardToday
  }

}