<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="employee.aspx.cs" Inherits="MDB.employee" %>
<%@ Register Src="~/Controls/ReqTextBox.ascx" TagPrefix="MDB" TagName="ReqTextBox" %>
<%@ Register Assembly="MDB" Namespace="MDB.AppCode" TagPrefix="MDB" %>
<%@ Register Src="~/Controls/DetailsTooltip.ascx" TagPrefix="MDB" TagName="DetailsTooltip" %>
<%@ Register Src="~/Controls/ShowLog.ascx" TagPrefix="MDB" TagName="ShowLog" %>
<%@ Register Src="~/Controls/Comments.ascx" TagPrefix="MDB" TagName="Comments" %>
<%@ Register Src="~/Controls/HoverMenu.ascx" TagPrefix="MDB" TagName="HoverMenu" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <div class="left">
        <asp:Label ID="lblMessage" runat="server" Text="lblMessage" Visible="false"></asp:Label>
        <asp:DetailsView ID="dvEmployee" runat="server"
            CssClass="detailsview list"
            AutoGenerateRows="False"
            DataKeyNames="Id"
            DataSourceID="sdsEmployee"
            OnDataBound="dvEmployee_DataBound"
            OnItemInserting="dvEmployee_ItemInserting"
            OnItemUpdating="dvEmployee_ItemUpdating">
            <Fields>
                <asp:BoundField DataField="Id" Visible="false" HeaderText="Id" ReadOnly="True" SortExpression="Id" />
                <asp:TemplateField HeaderText="MANR" SortExpression="MANR">
                    <EditItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtMANR" CheckIfExists="Employee" MinLength="1" MaxLength="6" PropertyText="MANR" Text='<%# Bind("MANR") %>' />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtMANR" CheckIfExists="Employee" MinLength="1" MaxLength="6" PropertyText="MANR" Text='<%# Bind("MANR") %>' />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblMANR" runat="server" Text='<%# Bind("MANR") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Stabsnummer" SortExpression="Stabsnummer" ConvertEmptyStringToNull="false">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtStabsnummer" runat="server" Text='<%# Bind("Stabsnummer") %>' MaxLength="12"></asp:TextBox>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:TextBox ID="txtStabsnummer" runat="server" Text='<%# Bind("Stabsnummer") %>' MaxLength="12"></asp:TextBox>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblStabsnummer" runat="server" Text='<%# Bind("Stabsnummer") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Navn" SortExpression="Name">
                    <EditItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtName" MinLength="1" MaxLength="100" PropertyText="Navn" Text='<%# Bind("Name") %>' />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtName" MinLength="1" MaxLength="100" PropertyText="Navn" Text='<%# Bind("Name") %>' />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Underskrevet Tro- og love" SortExpression="SignedSolemnDeclaration">
                    <EditItemTemplate>
                        <asp:CheckBox ID="chkbxSignedSolemnDeclaration" Checked='<%# Bind("SignedSolemnDeclaration") %>' runat="server" />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:CheckBox ID="chkbxSignedSolemnDeclaration" Checked='<%# Bind("SignedSolemnDeclaration") %>' runat="server" />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblSignedSolemnDeclaration" runat="server" Text='<%# (bool)Eval("SignedSolemnDeclaration") ? "Ja" : "Nej" %>' />
                        <asp:Image ID="imgSignedSolemnDeclaration" Height="12" Visible='<%# Globals.CanUserWrite() %>' ImageUrl="~/Content/images/icon_info.png" runat="server" />
                        <MDB:HoverMenu runat="server" Enabled='<%# Globals.CanUserWrite() %>' TargetControlID="imgSignedSolemnDeclaration" ID="HoverMenu">
                            <Content>
                                <asp:LinkButton ID="lnkbtnSetSignedSolemnDeclaration" runat="server" Visible='<%# !(bool)Eval("SignedSolemnDeclaration") %>' OnClick="lnkbtnSetSignedSolemnDeclaration_Click">Sæt Underskrevet til Ja</asp:LinkButton>
                                <asp:HyperLink ID="hplDownloadSolemnDeclaration" runat="server" NavigateUrl='<%# $"~/download.ashx?f=trolove{Eval("MANR")}.docx" %>'>Download Tro- og love</asp:HyperLink>
                            </Content>
                        </MDB:HoverMenu>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Noter" SortExpression="Notes" ConvertEmptyStringToNull="false">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtNotes" runat="server" Text='<%# Bind("Notes") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:TextBox ID="txtNotes" runat="server" Text='<%# Bind("Notes") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblNotes" runat="server" Text='<%# Eval("Notes").ToString().Replace("\n", "<br>") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ShowHeader="False">
                    <InsertItemTemplate>
                        <asp:LinkButton ID="lnkbtnInsert" runat="server" CausesValidation="True" CommandName="Insert" Text="Opret"></asp:LinkButton>
                    </InsertItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="lnkbtnDelete" runat="server" CausesValidation="False" OnClientClick="return confirm('Er du sikker på at du vil slette denne medarbejder?')" CommandName="Delete" Text="Slet"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="lnkbtnUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Gem"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="lnkbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Annuller"></asp:LinkButton>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkbtnEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Rediger"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Fields>
        </asp:DetailsView>
        <asp:ValidationSummary ID="vsChange" CssClass="valsum" runat="server" />
        <asp:SqlDataSource ID="sdsEmployee" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            SelectCommand="SELECT * FROM [Employees] WHERE ([Id] = @Id)"
            OnInserting="sdsEmployee_Changing" OnUpdating="sdsEmployee_Changing" OnDeleting="sdsEmployee_Changing"
            OnInserted="sdsEmployee_Inserted" OnUpdated="sdsEmployee_Updated" OnDeleted="sdsEmployee_Deleted"
            InsertCommand="EmployeeInsert" InsertCommandType="StoredProcedure"
            UpdateCommand="EmployeeUpdate" UpdateCommandType="StoredProcedure"
            DeleteCommand="EmployeeDelete" DeleteCommandType="StoredProcedure">
            <SelectParameters>
                <asp:RouteParameter Name="Id" RouteKey="Id" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="Executor" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="MANR" Type="String" />
                <asp:Parameter Name="Stabsnummer" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="SignedSolemnDeclaration" Type="Boolean" />
                <asp:Parameter Name="Notes" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="Executor" Type="String" />
                <asp:Parameter Name="LastId" Type="Int32" Direction="Output" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="MANR" Type="String" />
                <asp:Parameter Name="Stabsnummer" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="SignedSolemnDeclaration" Type="Boolean" />
                <asp:Parameter Name="Notes" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="Executor" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
    <div class="right">
        <MDB:Comments runat="server" ID="Comments" />
    </div>
    <div style="clear:both;"></div>
    <br />
    <asp:GridView ID="gvCurrentOrders" runat="server" CssClass="gridview list" AllowSorting="True" OnRowCommand="gvCurrentOrders_RowCommand" AllowPaging="True" PageSize="20" AutoGenerateColumns="False" DataSourceID="sdsCurrentOrders">
        <Columns>
            <asp:BoundField DataField="OrderId" HeaderText="Ordre" SortExpression="OrderId" />
            <asp:TemplateField HeaderText="Genstand" SortExpression="ObjectNumber">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="hplObject" NavigateUrl='<%# $"~/order/{Eval("OrderId")}" %>'
                        Text='<%# ((int)Eval("ObjectTypeRefId") == 3 ? "IMEI " : "SIMNR ") + Eval("ObjectNumber") %>' />
                    <asp:Image ID="imgNotApproved" Height="12" Visible='<%# !(bool)Eval("Approved") %>' ImageUrl="~/Content/images/icon_redwarning.png" runat="server" />
                    <MDB:HoverMenu runat="server" Enabled='<%# Globals.CanUserWrite() %>' TargetControlID="hplObject" ID="HoverMenu">
                        <Content>
                            <asp:LinkButton ID="lnkbtnApprove" runat="server" Visible='<%# !(bool)Eval("Approved") %>' Text="Bekræft ny stilling" CommandName="Approve" CommandArgument='<%# Eval("OrderId") %>' />
                            <asp:LinkButton ID="lnkbtnStorage" runat="server" Text="Sæt på Lager" CommandName="Storage" CommandArgument='<%# Eval("OrderId") %>' />
                        </Content>
                    </MDB:HoverMenu>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Info" HeaderText="Nummer/model" SortExpression="Info" />
            <asp:BoundField DataField="TimeStamp" HeaderText="Ændringsdato" DataFormatString="{0:dd-MM-yyyy}" SortExpression="TimeStamp" />
            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
            <asp:BoundField DataField="TaxType" HeaderText="Beskatning" SortExpression="TaxType" />
            <asp:TemplateField HeaderText="Note" SortExpression="Notes">
                <ItemTemplate>
                    <MDB:DetailsTooltip runat="server" ID="DetailsTooltip" Text='<%# Bind("Notes") %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsCurrentOrders" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [CurrentOrdersView] WHERE ([EmployeeId] = @EmployeeId)">
        <SelectParameters>
            <asp:RouteParameter Name="EmployeeId" RouteKey="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <br />
    <MDB:ShowLog runat="server" ID="ShowLog" />
</asp:Content>