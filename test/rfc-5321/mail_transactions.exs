defmodule MailTransactionTest do
  use ExUnit.Case

  @tag :pending
  test "reject MAIL transaction if FROM reverse-path is not valid format" do
  end


  @tag :pending
  test "" do
  end


  @tag :pending
  test "second MAIL command should start new mail transaction" do
  end


  @tag :pending
  test "reject MAIL command when another mail transaction is in progress" do
  end


  @tag :pending
  test "accept source routing for backward compatability, but do not process it" do
  end


  @tag :pending
  test "allow multiple RCPT TO forward-paths per mail transaction" do
  end


  @tag :pending
  test "250 reply to accepted RCPT TO commands" do
  end


  @tag :pending
  test "550 reply if RCPT TO is not a deliverable address" do
  end


  @tag :pending
  test "503 reply if RCPT TO appears outside of a MAIL transaction" do
  end


  @tag :pending
  test "wait after DATA command to accept data until end-of-mail-data indicator" do
  end


  @tag :pending
  test "a line with a dot is used as end-of-mail-data indicator" do
  end


  @tag :pending
  test "resume command-reply dialog after end-of-mail-data" do
  end


  @tag :pending
  test "process mail transaction after end-of-mail-data indicator" do
  end


  @tag :pending
  test "503 reply if DATA command is outside of mail transaction" do
  end


  @tag :pending
  test "client should not send message data unless 354 reply is received" do
  end



  @tag :pending
  test "should generate bounce notification on delivery failure" do
  end


  # implementation choice
  @tag :pending
  test "252 default reply to VRFY" do
  end


  @tag :pending
  test "EXPN should be listed as service extension if supported" do
  end


  @tag :pending
  test "multiple 250 replies to EXPN if enabled" do
  end
end
