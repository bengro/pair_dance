defmodule PairDanceWeb.MemberLive.FormComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage member records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="member-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Member</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{member: member} = assigns, socket) do
    changeset = Teams.change_member(member)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"member" => member_params}, socket) do
    changeset =
      socket.assigns.member
      |> Teams.change_member(member_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"member" => member_params}, socket) do
    save_member(socket, socket.assigns.action, member_params)
  end

  defp save_member(socket, :edit, member_params) do
    case Teams.update_member(socket.assigns.member, member_params) do
      {:ok, _member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Member updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_member(socket, :new, member_params) do
    case Teams.create_member(member_params) do
      {:ok, _member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Member created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
