using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using MDB.AppCode;

namespace MDB.admin
{
    public partial class user : Page
    {
        RandomPassword rndPassword = Globals.GetRandomPassword();

        protected void Page_Load(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (!IsPostBack)
            {
                string username = Page.RouteData.Values["username"].ToString();
                if (!String.IsNullOrWhiteSpace(username))
                {
                    MDBUser u = MDBUser.GetUser(username);
                    FillInfo(u);

                    if (u == null)
                        SetMessage("Bruger findes ikke", true);
                }
                else
                    FillInfo();
            }
        }

        private void FillInfo(MDBUser u = null)
        {
            if (u != null)
            {
                txtUsername.Text = u.UserName;
                txtFirstname.Text = u.Firstname;
                txtLastname.Text = u.Lastname;
                ddlType.SelectedValue = ((int)u.Type).ToString();
                chkbxEnabled.Checked = u.Enabled;
                chkbxLocked.Visible = u.IsLockedOut;
                chkbxLocked.Checked = u.IsLockedOut;
                lblNotLocked.Visible = !u.IsLockedOut;
            }
            else
            {
                txtUsername.Text = "";
                txtFirstname.Text = "";
                txtLastname.Text = "";
                ddlType.SelectedIndex = 0;
            }

            btnCreateUser.Visible = u == null;
            trEnabled.Visible = trLocked.Visible = trResetPassword.Visible = btnUpdateUser.Visible = btnDeleteUser.Visible = txtUsername.ReadOnly = u != null;
        }

        private void SetMessage(string message, bool isError = false)
        {
            lblMsg.Text = message;
            lblMsg.Visible = true;
            lblMsg.CssClass = isError ? "error" : "";
        }

        protected void btnCreateUser_Click(object sender, EventArgs e)
        {
            string password = rndPassword.GeneratePassword();
            try
            {
                MDBUser.CreateUser(txtUsername.Text, password, txtFirstname.Text, txtLastname.Text, (MDBUser.UserType)int.Parse(ddlType.SelectedValue));
                tblUser.Visible = false;
                SetMessage($"{txtUsername.Text} blev oprettet med password {password}");
            }
            catch (MembershipCreateUserException ex)
            {
                if (ex.StatusCode == MembershipCreateStatus.DuplicateUserName)
                    SetMessage("MANR er oprettet i forvejen", true);
            }
        }

        protected void btnUpdateUser_Click(object sender, EventArgs e)
        {
            MDBUser u = MDBUser.GetUser(txtUsername.Text);
            if (u.IsLockedOut && !chkbxLocked.Checked && chkbxResetPassword.Checked)
                SetMessage("Password kan ikke nulstilles uden at låse brugeren op", true);
            else
            {
                u.Firstname = txtFirstname.Text;
                u.Lastname = txtLastname.Text;
                u.Type = (MDBUser.UserType)int.Parse(ddlType.SelectedValue);
                u.Enabled = chkbxEnabled.Checked;
                string newPassword = u.Save(chkbxLocked.Checked, chkbxResetPassword.Checked);

                if (chkbxResetPassword.Checked)
                    SetMessage($"Bruger gemt og password nulstillet til: {newPassword}");
                else
                    SetMessage($"Bruger gemt");

                chkbxResetPassword.Checked = false;

                if (chkbxLocked.Checked)
                    chkbxLocked.Checked = false;
            }
        }

        protected void btnDeleteUser_Click(object sender, EventArgs e)
        {
            string username = Page.RouteData.Values["username"].ToString();
            MDBUser.Delete(username);
            Response.Redirect("~/admin/users.aspx");
        }

        //protected void btnDisableUser_Click(object sender, EventArgs e)
        //{
        //    MDBUser u = MDBUser.GetUser(txtUsername.Text);
        //}
    }
}