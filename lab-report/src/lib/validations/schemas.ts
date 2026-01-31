import { z } from "zod";

export const filterClientesSchema = z.object({
  segmento: z.enum(['Premium', 'Regular', 'Básico', 'Todos']).default('Todos'),
  limit: z.number().min(1).max(100).default(20),
});

export const paginationSchema = z.object({
  page: z.number().min(1).default(1),
  limit: z.number().min(1).max(50).default(10),
});

export type FilterClientesInput = z.infer<typeof filterClientesSchema>;
export type PaginationInput = z.infer<typeof paginationSchema>;