defmodule ChatApi.ConversationsTest do
  use ChatApi.DataCase, async: true

  alias ChatApi.Conversations

  describe "conversations" do
    alias ChatApi.Conversations.Conversation

    @valid_attrs %{status: "open"}
    @update_attrs %{status: "closed"}
    @invalid_attrs %{status: nil}

    def valid_create_attrs do
      account = account_fixture()

      Enum.into(@valid_attrs, %{account_id: account.id})
    end

    setup do
      account = account_fixture()
      customer = customer_fixture(account)
      conversation = conversation_fixture(account, customer)

      {:ok, account: account, conversation: conversation}
    end

    test "list_conversations/0 returns all conversations", %{
      conversation: conversation
    } do
      result_ids = Enum.map(Conversations.list_conversations(), fn r -> r.id end)

      assert result_ids == [conversation.id]
    end

    test "list_conversations_by_account/1 returns all conversations for an account", %{
      account: account,
      conversation: conversation
    } do
      different_account = account_fixture()
      different_customer = customer_fixture(different_account)
      _conversation = conversation_fixture(different_account, different_customer)

      result_ids = Enum.map(Conversations.list_conversations_by_account(account.id), & &1.id)

      assert result_ids == [conversation.id]
    end

    test "get_conversation!/1 returns the conversation with given id", %{
      conversation: conversation
    } do
      assert Conversations.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation" do
      assert {:ok, %Conversation{} = conversation} =
               Conversations.create_conversation(valid_create_attrs())

      assert conversation.status == "open"
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation", %{
      conversation: conversation
    } do
      assert {:ok, %Conversation{} = conversation} =
               Conversations.update_conversation(conversation, @update_attrs)

      assert conversation.status == "closed"
    end

    test "update_conversation/2 with invalid data returns error changeset", %{
      conversation: conversation
    } do
      assert {:error, %Ecto.Changeset{}} =
               Conversations.update_conversation(conversation, @invalid_attrs)

      assert conversation = Conversations.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation", %{conversation: conversation} do
      assert {:ok, %Conversation{}} = Conversations.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> Conversations.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset", %{conversation: conversation} do
      assert %Ecto.Changeset{} = Conversations.change_conversation(conversation)
    end
  end
end
