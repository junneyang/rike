<%@page import="javax.portlet.RenderResponse"%>
<%@page import="de.arago.portlet.util.SecurityHelper"%>
<%@page import="de.arago.rike.commons.data.TaskUser"%>
<%@page import="de.arago.rike.commons.util.ViewHelper"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.List"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<portlet:defineObjects />

<%
    try {
        List<TaskUser> list = (List<TaskUser>) portletSession.getAttribute("list");
        //User user = SecurityHelper.getUser(renderRequest.getRemoteUser());
%>

<div class="portlet big <%= renderRequest.getWindowState().equals(WindowState.MAXIMIZED) ? "maximized" : ""%>" style="" id="<portlet:namespace />Portlet">
  <div class="portletbox">
    <!-- head -->
    <div class="head">
      <h1>
        <div class="ellipsis">
          Leaderboard
        </div>
        <span class="right">
          <a href="javascript:void(0);" onclick="return de.arago.help.Provider.show('rike.leaderboard');" title="Help" class="icon-question"></a> 
          <% if (renderRequest.getWindowState().equals(WindowState.MAXIMIZED)) {%>
          <a href="<portlet:actionURL portletMode="view" windowState="normal"/>" title="Minimize" class="icon-resize-small"></a>
          <% } else {%>
          <a href="<portlet:actionURL portletMode="view" windowState="maximized"/>" title="Maximize" class="icon-resize-full"></a>
          <% }%>
        </span>
      </h1>
    </div>
    <div class="content nohead nofooter">

      <div class="tablescroll max" id="<portlet:namespace />TableScroll">
           <ol class="toplist">
              <% for (int k = 0; k < 2; k++) {%>
            
                    <%
                       
                        int i = 1;
                        for (TaskUser user : list) {
                            if (i % 2 != k) {

                                String klass = "";
                                long sum = user.getAccount() - user.getYesterday();

                                if (sum > 0) {
                                    klass = "place-down";
                                } else if (sum < 0) {
                                    klass = "place-up";
                                } else {
                                    klass = "place-unchanged";
                                }

                                int[] points = user.getEnded_tasks();
                                String str = "" + points[0];
                                for (int j = 1; j < points.length; j++) {
                                    str += "/" + points[j];
                                }
                    %>
                    <li>
                           	<div class="inner">
                              <img class="avatar" src="/arago-rike/avatar/<%= StringEscapeUtils.escapeHtml(user.getEmail().replaceFirst("@.+$", "") + "-" + klass + ".png")%>" alt="" />
                     		<h2> <%= i%>. <%= ViewHelper.formatUser(user.getEmail())%></h2>
                               <div class="current">Current points: <%=str%> </div>
                               <div class="lastweek" title="Place last week: ">Place last week: <span class="icon-arrow-up green"></span>(<%=user.getYesterday()%>)</div>
                           	</div>
                     </li>
                      
                    <%
                            }
                            ++i;
                        }
                    %>
              <% }%>
</ol>
      </div>

      <script type="text/javascript">
            $(function()
            {
              $('#<portlet:namespace/>TableScroll').height($('#<portlet:namespace />Portlet').height() - 36).show();
            });
      </script>
    </div>
  </div>
</div>
<% 
    } catch (Throwable t) {
        out.write("Please Reload");
        t.printStackTrace(System.err);
    }
%>
