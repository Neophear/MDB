<%@ Page Title="Ændringslog" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="changelog.aspx.cs" Inherits="MDB.admin.changelog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:DetailsView ID="dvChangeLog" runat="server" CssClass="detailsview" AutoGenerateRows="False" DefaultMode="Insert" OnItemUpdated="dvChangeLog_ItemUpdated" OnItemInserted="dvChangeLog_ItemInserted" DataKeyNames="ID" DataSourceID="sdsWriteChangeLog">
        <Fields>
            <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
            <asp:BoundField DataField="Text" HeaderText="Tekst" SortExpression="Text" />
            <asp:CheckBoxField DataField="VisibleToRead" HeaderText="Synlig for Read" SortExpression="VisibleToRead" />
            <asp:CheckBoxField DataField="VisibleToWrite" HeaderText="Synlig for Write" SortExpression="VisibleToWrite" />
            <asp:TemplateField ShowHeader="False">
                <EditItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Opdater"></asp:LinkButton>
                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Annuller"></asp:LinkButton>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Insert" Text="Indsæt"></asp:LinkButton>
                </InsertItemTemplate>
            </asp:TemplateField>
        </Fields>
    </asp:DetailsView>
    <asp:SqlDataSource ID="sdsWriteChangeLog" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT [Id], [Text], [VisibleToRead], [VisibleToWrite] FROM [ChangeLog] WHERE ([Id] = @Id)"
        InsertCommand="ChangeLogInsert" InsertCommandType="StoredProcedure"
        UpdateCommand="ChangeLogUpdate" UpdateCommandType="StoredProcedure"
        OnInserting="sdsWriteChangeLog_Changing" OnUpdating="sdsWriteChangeLog_Changing" OnDeleting="sdsWriteChangeLog_Changing">
        <InsertParameters>
            <asp:Parameter Name="Text" Type="String" />
            <asp:Parameter Name="VisibleToRead" Type="Boolean" />
            <asp:Parameter Name="VisibleToWrite" Type="Boolean" />
            <asp:Parameter Name="Executor" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="gvChangeLog" Name="Id" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Id" Type="Int32" />
            <asp:Parameter Name="Text" Type="String" />
            <asp:Parameter Name="VisibleToRead" Type="Boolean" />
            <asp:Parameter Name="VisibleToWrite" Type="Boolean" />
            <asp:Parameter Name="Executor" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <br />
    <asp:GridView ID="gvChangeLog" runat="server" CssClass="gridview list" AutoGenerateColumns="False" OnSelectedIndexChanged="gvChangeLog_SelectedIndexChanged" DataKeyNames="Id" DataSourceID="sdsChangeLog">
        <Columns>
            <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ItemStyle-Width="30" ReadOnly="True" SortExpression="Id" />
            <asp:BoundField DataField="Timestamp" DataFormatString="{0:dd-MM-yy HH:mm}" ItemStyle-Width="110" HeaderText="Timestamp" SortExpression="Timestamp" />
            <asp:BoundField DataField="Text" HeaderText="Text" SortExpression="Text" />
            <asp:BoundField DataField="VisibleToRead" HeaderText="Synlig for Read" SortExpression="VisibleToRead" />
            <asp:BoundField DataField="VisibleToWrite" HeaderText="Synlig for Write" SortExpression="VisibleToWrite" />
            <asp:CommandField ShowSelectButton="True" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsChangeLog" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [ChangeLog] ORDER BY [Timestamp] DESC">
    </asp:SqlDataSource>
</asp:Content>