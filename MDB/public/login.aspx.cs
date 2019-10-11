using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using MDB.AppCode;

namespace MDB.Public
{
    public partial class login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
                Response.Redirect("~/");

            //Fjernes ved live!
            if (Membership.GetUser("370929") == null)
                MDBUser.CreateUser("370929", "test1234", "Stiig", "Gade", MDBUser.UserType.Admin);
            if (Membership.GetUser("417317") == null)
                MDBUser.CreateUser("417317", "test1234", "Thomas", "á Rogvi", MDBUser.UserType.Admin);
            ///////////////////////////
        }

        protected void Login1_LoginError(object sender, EventArgs e)
        {
            MembershipUser u = Membership.GetUser(Login1.UserName);
            if (u == null)
                Login1.FailureText = "Du blev ikke logget ind.";
            else if (u.IsLockedOut)
                Login1.FailureText = "Din konto er låst.";
            else if (!u.IsApproved)
                Login1.FailureText = "Din konto er deaktiveret.";
            else
                Login1.FailureText = "Du blev ikke logget ind.";
        }
    }
}