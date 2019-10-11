<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="customtable.aspx.cs" Inherits="MDB.admin.customtable" %>
<%@ Register Src="~/Controls/ReqTextBox.ascx" TagPrefix="MDB" TagName="ReqTextBox" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblMessage" runat="server" CssClass="error" Text="lblMessage" Visible="false" />
    <div class="customtable">
        <div>
            <asp:ListBox ID="lstbxPresets" runat="server" DataSourceID="sdsPresets" DataValueField="Id" DataTextField="Name" OnSelectedIndexChanged="lstbxPresets_SelectedIndexChanged" AutoPostBack="true" />
            <asp:SqlDataSource ID="sdsPresets" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [SQLPresets]" />
        </div>
        <asp:DetailsView ID="dvPreset" CssClass="detailsview list" runat="server" DefaultMode="Insert" DataSourceID="sdsPreset" AutoGenerateRows="False" DataKeyNames="Id"
            OnDataBound="dvPreset_DataBound">
            <Fields>
                <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" Visible="false" ReadOnly="True" SortExpression="Id" />
                <asp:TemplateField HeaderText="Name" SortExpression="Name">
                    <EditItemTemplate>
                        <MDB:ReqTextBox runat="server" MaxLength="50" MinLength="1" CheckIfExists="SQLPreset" ID="rtxtName" Text='<%# Bind("Name") %>' />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <MDB:ReqTextBox runat="server" MaxLength="50" MinLength="1" CheckIfExists="SQLPreset" ID="rtxtName" Text='<%# Bind("Name") %>' />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description" SortExpression="Description">
                    <EditItemTemplate>
                        <MDB:ReqTextBox runat="server" MaxLength="500" MinLength="1" ID="rtxtDescription" Text='<%# Bind("Description") %>' />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <MDB:ReqTextBox runat="server" MaxLength="500" MinLength="1" ID="rtxtDescription" Text='<%# Bind("Description") %>' />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblDescription" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="VisibleToRoles">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkbxVisibleToRolesRead" Enabled="false" Text="Read" Checked='<%# Bind("VisibleToRead") %>' runat="server" />
                        <asp:CheckBox ID="chkbxVisibleToRolesWrite" Enabled="false" Text="Write" Checked='<%# Bind("VisibleToWrite") %>' runat="server" />
                    </ItemTemplate>
                    <InsertItemTemplate>
                        <asp:CheckBox ID="chkbxVisibleToRolesRead" Text="Read" Checked='<%# Bind("VisibleToRead") %>' runat="server" />
                        <asp:CheckBox ID="chkbxVisibleToRolesWrite" Text="Write" Checked='<%# Bind("VisibleToWrite") %>' runat="server" />
                    </InsertItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox ID="chkbxVisibleToRolesRead" Text="Read" Checked='<%# Bind("VisibleToRead") %>' runat="server" />
                        <asp:CheckBox ID="chkbxVisibleToRolesWrite" Text="Write" Checked='<%# Bind("VisibleToWrite") %>' runat="server" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="VisibleToUsers">
                    <ItemTemplate>
                        <asp:CheckBoxList ID="chkbxlstVisibleToUsers" CssClass="customtable" RepeatColumns="3" RepeatLayout="Table" runat="server" />
                    </ItemTemplate>
                    <InsertItemTemplate>
                        <asp:CheckBoxList ID="chkbxlstVisibleToUsers" CssClass="customtable" RepeatColumns="3" RepeatLayout="Table" runat="server" />
                    </InsertItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBoxList ID="chkbxlstVisibleToUsers" CssClass="customtable" RepeatColumns="3" RepeatLayout="Table" runat="server" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Query">
                    <ItemTemplate>
                        <div>
                            <asp:Label ID="lblQuery" Text='<%# Bind("Query") %>' runat="server" />
                            <asp:Button ID="btnRunQuery" runat="server" OnClick="btnRunQuery_Click" Text="Kør" />
                        </div>
                    </ItemTemplate>
                    <InsertItemTemplate>
                        <div>
                            <asp:TextBox runat="server" ID="txtQuery" TextMode="MultiLine" Text='<%# Bind("Query") %>' placeholder="SELECT * FROM [Devices]" />
                            <asp:Button ID="btnRunQuery" runat="server" OnClick="btnRunQuery_Click" Text="Kør" />
                        </div>
                    </InsertItemTemplate>
                    <EditItemTemplate>
                        <div>
                            <asp:TextBox runat="server" ID="txtQuery" TextMode="MultiLine" Text='<%# Bind("Query") %>' placeholder="SELECT * FROM [Devices]" />
                            <asp:Button ID="btnRunQuery" runat="server" OnClick="btnRunQuery_Click" Text="Kør" />
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ShowHeader="False">
                    <InsertItemTemplate>
                        <asp:LinkButton ID="lnkbtnInsert" runat="server" CausesValidation="True" CommandName="Insert" Text="Opret"></asp:LinkButton>
                    </InsertItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="lnkbtnUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Gem"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="lnkbtnEditCancel" runat="server" CausesValidation="False" OnClick="lnkbtnEditCancel_Click" Text="Annuller"></asp:LinkButton>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkbtnEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Rediger"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="lnkbtnReadOnlyCancel" runat="server" CausesValidation="False" OnClick="lnkbtnReadOnlyCancel_Click" Text="Annuller"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Fields>
        </asp:DetailsView>
        <asp:SqlDataSource ID="sdsPreset" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            SelectCommand="SELECT * FROM [SQLPresets] WHERE ([Id] = @Id)"
            OnInserting="sdsPreset_Changing" OnUpdating="sdsPreset_Changing"
            InsertCommand="SQLPresetInsert" InsertCommandType="StoredProcedure"
            UpdateCommand="SQLPresetUpdate" UpdateCommandType="StoredProcedure"
            DeleteCommand="SQLPresetDelete" DeleteCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="lstbxPresets" Name="Id" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="VisibleToRead" Type="Boolean" />
                <asp:Parameter Name="VisibleToWrite" Type="Boolean" />
                <asp:Parameter Name="VisibleToUsers" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Query" Type="String" />
                <asp:Parameter Name="Executor" Type="String" />
                <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="VisibleToRead" Type="Boolean" />
                <asp:Parameter Name="VisibleToWrite" Type="Boolean" />
                <asp:Parameter Name="VisibleToUsers" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Query" Type="String" />
                <asp:Parameter Name="Executor" Type="String" />
                <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="Executor" Type="String" />
                <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <div class="infobox">
            <div>
                <img src="/Content/images/icon_info.png" class="icon" />
            </div>
            <div>
                <asp:Label Text="En bruger kan se/bruge en SQLPreset hvis han/hun opfylder en af kravene to Visibility. Så brugeren skal bare enten have den valgte rolle eller være valgt direkte." runat="server" />
            </div>
        </div>
    </div>
    <br />
    <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Visible="false" Text="Download CSV" /><br /><br />
    <asp:GridView ID="gvResult" OnDataBound="gvResult_DataBound" AllowSorting="true" OnSorting="gvResult_Sorting" CssClass="gridview list" runat="server"></asp:GridView>
</asp:Content>