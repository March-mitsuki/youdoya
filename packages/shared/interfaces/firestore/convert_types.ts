import { ToDoit } from "@doit/shared";
import { FieldValue, Timestamp } from "firebase/firestore";

// id is doc.id, not in doc.data
export type FirestoreTodoType = {
  locale: string;
  timezome: string;
  create_date: string; // ISO 8601 string, client create date
  finish_date: string; // ISO 8601 string, client create date
  finish_date_obj: ToDoit.DateObj;
  priority: ToDoit.Priority;
  content: string;
  is_finish: boolean;
  created_at: Timestamp; // serverTimestamp
  updated_at: Timestamp; // serverTimestamp
};

export type CreateFirestoreTodo = Omit<FirestoreTodoType, "id" | "created_at" | "updated_at"> & {
  created_at: FieldValue;
  updated_at: FieldValue;
};