defmodule Homesynck.SyncTest do
  use Homesynck.DataCase

  alias Homesynck.Sync

  describe "updates" do
    alias Homesynck.Sync.Update

    @valid_attrs %{rank: "some rank"}
    @update_attrs %{rank: "some updated rank"}
    @invalid_attrs %{rank: nil}

    def update_fixture(attrs \\ %{}) do
      {:ok, update} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sync.create_update()

      update
    end

    test "list_updates/0 returns all updates" do
      update = update_fixture()
      assert Sync.list_updates() == [update]
    end

    test "get_update!/1 returns the update with given id" do
      update = update_fixture()
      assert Sync.get_update!(update.id) == update
    end

    test "create_update/1 with valid data creates a update" do
      assert {:ok, %Update{} = update} = Sync.create_update(@valid_attrs)
      assert update.rank == "some rank"
    end

    test "create_update/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sync.create_update(@invalid_attrs)
    end

    test "update_update/2 with valid data updates the update" do
      update = update_fixture()
      assert {:ok, %Update{} = update} = Sync.update_update(update, @update_attrs)
      assert update.rank == "some updated rank"
    end

    test "update_update/2 with invalid data returns error changeset" do
      update = update_fixture()
      assert {:error, %Ecto.Changeset{}} = Sync.update_update(update, @invalid_attrs)
      assert update == Sync.get_update!(update.id)
    end

    test "delete_update/1 deletes the update" do
      update = update_fixture()
      assert {:ok, %Update{}} = Sync.delete_update(update)
      assert_raise Ecto.NoResultsError, fn -> Sync.get_update!(update.id) end
    end

    test "change_update/1 returns a update changeset" do
      update = update_fixture()
      assert %Ecto.Changeset{} = Sync.change_update(update)
    end
  end

  describe "updates" do
    alias Homesynck.Sync.Update

    @valid_attrs %{instructions: "some instructions", rank: 42}
    @update_attrs %{instructions: "some updated instructions", rank: 43}
    @invalid_attrs %{instructions: nil, rank: nil}

    def update_fixture(attrs \\ %{}) do
      {:ok, update} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sync.create_update()

      update
    end

    test "list_updates/0 returns all updates" do
      update = update_fixture()
      assert Sync.list_updates() == [update]
    end

    test "get_update!/1 returns the update with given id" do
      update = update_fixture()
      assert Sync.get_update!(update.id) == update
    end

    test "create_update/1 with valid data creates a update" do
      assert {:ok, %Update{} = update} = Sync.create_update(@valid_attrs)
      assert update.instructions == "some instructions"
      assert update.rank == 42
    end

    test "create_update/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sync.create_update(@invalid_attrs)
    end

    test "update_update/2 with valid data updates the update" do
      update = update_fixture()
      assert {:ok, %Update{} = update} = Sync.update_update(update, @update_attrs)
      assert update.instructions == "some updated instructions"
      assert update.rank == 43
    end

    test "update_update/2 with invalid data returns error changeset" do
      update = update_fixture()
      assert {:error, %Ecto.Changeset{}} = Sync.update_update(update, @invalid_attrs)
      assert update == Sync.get_update!(update.id)
    end

    test "delete_update/1 deletes the update" do
      update = update_fixture()
      assert {:ok, %Update{}} = Sync.delete_update(update)
      assert_raise Ecto.NoResultsError, fn -> Sync.get_update!(update.id) end
    end

    test "change_update/1 returns a update changeset" do
      update = update_fixture()
      assert %Ecto.Changeset{} = Sync.change_update(update)
    end
  end

  describe "updates_received" do
    alias Homesynck.Sync.UpdateReceived

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def update_received_fixture(attrs \\ %{}) do
      {:ok, update_received} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sync.create_update_received()

      update_received
    end

    test "list_updates_received/0 returns all updates_received" do
      update_received = update_received_fixture()
      assert Sync.list_updates_received() == [update_received]
    end

    test "get_update_received!/1 returns the update_received with given id" do
      update_received = update_received_fixture()
      assert Sync.get_update_received!(update_received.id) == update_received
    end

    test "create_update_received/1 with valid data creates a update_received" do
      assert {:ok, %UpdateReceived{} = update_received} = Sync.create_update_received(@valid_attrs)
    end

    test "create_update_received/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sync.create_update_received(@invalid_attrs)
    end

    test "update_update_received/2 with valid data updates the update_received" do
      update_received = update_received_fixture()
      assert {:ok, %UpdateReceived{} = update_received} = Sync.update_update_received(update_received, @update_attrs)
    end

    test "update_update_received/2 with invalid data returns error changeset" do
      update_received = update_received_fixture()
      assert {:error, %Ecto.Changeset{}} = Sync.update_update_received(update_received, @invalid_attrs)
      assert update_received == Sync.get_update_received!(update_received.id)
    end

    test "delete_update_received/1 deletes the update_received" do
      update_received = update_received_fixture()
      assert {:ok, %UpdateReceived{}} = Sync.delete_update_received(update_received)
      assert_raise Ecto.NoResultsError, fn -> Sync.get_update_received!(update_received.id) end
    end

    test "change_update_received/1 returns a update_received changeset" do
      update_received = update_received_fixture()
      assert %Ecto.Changeset{} = Sync.change_update_received(update_received)
    end
  end

  describe "controllers" do
    alias Homesynck.Sync.Controller

    @valid_attrs %{last_online: ~D[2010-04-17], name: "some name"}
    @update_attrs %{last_online: ~D[2011-05-18], name: "some updated name"}
    @invalid_attrs %{last_online: nil, name: nil}

    def controller_fixture(attrs \\ %{}) do
      {:ok, controller} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sync.create_controller()

      controller
    end

    test "list_controllers/0 returns all controllers" do
      controller = controller_fixture()
      assert Sync.list_controllers() == [controller]
    end

    test "get_controller!/1 returns the controller with given id" do
      controller = controller_fixture()
      assert Sync.get_controller!(controller.id) == controller
    end

    test "create_controller/1 with valid data creates a controller" do
      assert {:ok, %Controller{} = controller} = Sync.create_controller(@valid_attrs)
      assert controller.last_online == ~D[2010-04-17]
      assert controller.name == "some name"
    end

    test "create_controller/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sync.create_controller(@invalid_attrs)
    end

    test "update_controller/2 with valid data updates the controller" do
      controller = controller_fixture()
      assert {:ok, %Controller{} = controller} = Sync.update_controller(controller, @update_attrs)
      assert controller.last_online == ~D[2011-05-18]
      assert controller.name == "some updated name"
    end

    test "update_controller/2 with invalid data returns error changeset" do
      controller = controller_fixture()
      assert {:error, %Ecto.Changeset{}} = Sync.update_controller(controller, @invalid_attrs)
      assert controller == Sync.get_controller!(controller.id)
    end

    test "delete_controller/1 deletes the controller" do
      controller = controller_fixture()
      assert {:ok, %Controller{}} = Sync.delete_controller(controller)
      assert_raise Ecto.NoResultsError, fn -> Sync.get_controller!(controller.id) end
    end

    test "change_controller/1 returns a controller changeset" do
      controller = controller_fixture()
      assert %Ecto.Changeset{} = Sync.change_controller(controller)
    end
  end
end
