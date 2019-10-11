<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="settings.aspx.cs" Inherits="MDB.admin.settings" %>
<%@ Register Src="~/Controls/ReqTextBox.ascx" TagPrefix="sg" TagName="ReqTextBox" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Panel CssClass="box" runat="server">
        <div>
            Myndigheder
        </div>
        <div>
            <asp:Label ID="lblUnitMessage" runat="server" Text="lblUnitMessage" Visible="false"></asp:Label>
            <asp:DetailsView ID="dvUnit" runat="server" CssClass="detailsview" DefaultMode="Insert" AutoGenerateRows="False" DataKeyNames="Id" DataSourceID="sdsUnit">
                <Fields>
                    <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
                    <asp:TemplateField HeaderText="Forkortelse" SortExpression="Short">
                        <EditItemTemplate>
                            <sg:ReqTextBox runat="server" ID="rtxtShort" MinLength="1" MaxLength="5" ValidationGroup="Unit" Text='<%# Bind("Short") %>' ErrorMessage="Forkortelsen skal være på mellem 1 og 5 karakterer"/>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <sg:ReqTextBox runat="server" ID="rtxtShort" MinLength="1" MaxLength="5" ValidationGroup="Unit" Text='<%# Bind("Short") %>' ErrorMessage="Forkortelsen skal være på mellem 1 og 5 karakterer"/>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Navn" SortExpression="Name">
                        <EditItemTemplate>
                            <sg:ReqTextBox runat="server" ID="rtxtName" MinLength="1" MaxLength="100" ValidationGroup="Unit" Text='<%# Bind("Name") %>' ErrorMessage="Navnet skal være på mellem 1 og 100 karakterer"/>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <sg:ReqTextBox runat="server" ID="rtxtName" MinLength="1" MaxLength="100" ValidationGroup="Unit" Text='<%# Bind("Name") %>' ErrorMessage="Navnet skal være på mellem 1 og 100 karakterer"/>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkbtnDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Slet" OnClientClick="return confirm('Er du sikker på at du vil slette denne enhed?')"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lnkbtnUpdate" runat="server" CausesValidation="True" ValidationGroup="Unit" CommandName="Update" Text="Gem"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lnkbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Annuller"></asp:LinkButton>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:LinkButton ID="lnkbtnInsert" runat="server" CausesValidation="True" ValidationGroup="Unit" CommandName="Insert" Text="Opret"></asp:LinkButton>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>
            <asp:ValidationSummary ID="vsUnit" ValidationGroup="Unit" CssClass="valsum" runat="server" />
            <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                SelectCommand="SELECT * FROM [Units] WHERE ([Id] = @Id)"
                OnInserting="sds_Changing" OnUpdating="sds_Changing" OnDeleting="sds_Changing"
                OnInserted="sdsUnit_Changed" OnUpdated="sdsUnit_Changed" OnDeleted="sdsUnit_Changed"
                InsertCommand="UnitInsert" InsertCommandType="StoredProcedure"
                UpdateCommand="UnitUpdate" UpdateCommandType="StoredProcedure"
                DeleteCommand="UnitDelete" DeleteCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="gvUnits" Name="Id" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <DeleteParameters>
                    <asp:Parameter Name="Id" Type="Int32" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Short" Type="String" />
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Id" Type="Int32" />
                    <asp:Parameter Name="Short" Type="String" />
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="gvUnits" CssClass="gridview list" OnSelectedIndexChanged="gvUnits_SelectedIndexChanged" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="sdsUnits" AllowSorting="True">
                <Columns>
                    <asp:CommandField ShowSelectButton="true" />
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="Short" HeaderText="Forkortelse" SortExpression="Short" />
                    <asp:BoundField DataField="Name" HeaderText="Navn" SortExpression="Name" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sdsUnits" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [Units] ORDER BY [Short]">
            </asp:SqlDataSource>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlChangeSolemnDeclaration" CssClass="box" runat="server">
        <div>
            Skift Tro- og love-dokument
        </div>
        <div>
            <asp:FileUpload ID="fuChangeSolemnDeclaration" runat="server" />
            <asp:Button ID="btnChangeSolemnDeclaration" runat="server" OnClick="btnChangeSolemnDeclaration_Click" Text="Upload" />
            <asp:Label ID="lblChangeSolemnDeclarationMessage" runat="server" Text="" Visible="false"></asp:Label>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlDataPlans" CssClass="box" runat="server">
        <div>
            Dataplaner til SIM-kort
        </div>
        <div>
            <asp:Label ID="lblDataPlanMessage" runat="server" Text="lblDataPlanMessage" Visible="false"></asp:Label>
            <asp:DetailsView ID="dvDataPlan" runat="server" CssClass="detailsview" DefaultMode="Insert" AutoGenerateRows="False" DataKeyNames="Id" DataSourceID="sdsDataPlan">
                <Fields>
                    <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
                    <asp:TemplateField HeaderText="Navn" SortExpression="Name">
                        <EditItemTemplate>
                            <sg:ReqTextBox runat="server" ID="rtxtName" MinLength="1" MaxLength="50" ValidationGroup="DataPlan" Text='<%# Bind("Name") %>' ErrorMessage="Navnet skal være på mellem 1 og 50 karakterer"/>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <sg:ReqTextBox runat="server" ID="rtxtName" MinLength="1" MaxLength="50" ValidationGroup="DataPlan" Text='<%# Bind("Name") %>' ErrorMessage="Navnet skal være på mellem 1 og 50 karakterer"/>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkbtnDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Slet" OnClientClick="return confirm('Er du sikker på at du vil slette denne dataplan?')"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lnkbtnUpdate" runat="server" CausesValidation="True" ValidationGroup="DataPlan" CommandName="Update" Text="Gem"></asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lnkbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Annuller"></asp:LinkButton>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:LinkButton ID="lnkbtnInsert" runat="server" CausesValidation="True" ValidationGroup="DataPlan" CommandName="Insert" Text="Opret"></asp:LinkButton>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>
            <asp:ValidationSummary ID="vsDataPlan" ValidationGroup="DataPlan" CssClass="valsum" runat="server" />
            <asp:SqlDataSource ID="sdsDataPlan" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                SelectCommand="SELECT * FROM [DataPlans] WHERE ([Id] = @Id)"
                OnInserting="sds_Changing" OnUpdating="sds_Changing" OnDeleting="sds_Changing"
                OnInserted="sdsDataPlan_Changed" OnUpdated="sdsDataPlan_Changed" OnDeleted="sdsDataPlan_Changed"
                InsertCommand="DataPlanInsert" InsertCommandType="StoredProcedure"
                UpdateCommand="DataPlanUpdate" UpdateCommandType="StoredProcedure"
                DeleteCommand="DataPlanDelete" DeleteCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="gvDataPlans" Name="Id" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <DeleteParameters>
                    <asp:Parameter Name="Id" Type="Int32" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Id" Type="Int32" />
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Executor" Type="String" />
                    <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="gvDataPlans" CssClass="gridview list" OnSelectedIndexChanged="gvDataPlans_SelectedIndexChanged" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="sdsDataPlans" AllowSorting="True">
                <Columns>
                    <asp:CommandField ShowSelectButton="true" />
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="Name" HeaderText="Navn" SortExpression="Name" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sdsDataPlans" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [DataPlans] ORDER BY [Name]">
            </asp:SqlDataSource>
        </div>
    </asp:Panel>
</asp:Content>