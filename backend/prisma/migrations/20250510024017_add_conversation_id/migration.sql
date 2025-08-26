/*
  Warnings:

  - A unique constraint covering the columns `[conversationId]` on the table `Conversation` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `conversationId` to the `Conversation` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Conversation" ADD COLUMN     "conversationId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Conversation_conversationId_key" ON "Conversation"("conversationId");
