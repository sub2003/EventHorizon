package com.eventhorizon.servlet;

import com.eventhorizon.model.Issue;
import com.eventhorizon.model.IssueReply;
import com.eventhorizon.service.IssueService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class IssueServlet extends HttpServlet {

    private final IssueService issueService = new IssueService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "report";

        HttpSession session = request.getSession(false);

        switch (action) {

            case "report": {
                if (session != null && session.getAttribute("userId") != null) {
                    int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
                    List<Issue> myIssues = issueService.getIssuesByUser(userId);
                    request.setAttribute("myIssues", myIssues);
                }

                request.getRequestDispatcher("/reportIssue.jsp").forward(request, response);
                break;
            }

            case "myIssues": {
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
                List<Issue> myIssues = issueService.getIssuesByUser(userId);
                request.setAttribute("myIssues", myIssues);
                request.getRequestDispatcher("/reportIssue.jsp").forward(request, response);
                break;
            }

            case "adminList": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                String adminType = getAdminType(session);
                String catFilter = request.getParameter("category");
                String statFilter = request.getParameter("status");

                List<Issue> issues;
                if ("CORE_ADMIN".equals(adminType)) {
                    issues = issueService.getIssuesByFilter(null, catFilter, statFilter);
                } else if ("EVENTS_AND_BOOKINGS_ADMIN".equals(adminType)) {
                    issues = issueService.getIssuesByFilter("EVENTS_ADMIN,BOOKINGS_ADMIN", catFilter, statFilter);
                } else {
                    issues = issueService.getIssuesByFilter(adminType, catFilter, statFilter);
                }

                request.setAttribute("issues", issues);
                request.setAttribute("adminType", adminType);
                request.setAttribute("catFilter", catFilter);
                request.setAttribute("statFilter", statFilter);
                request.setAttribute("openCount", issueService.countByStatus("OPEN", adminType));
                request.setAttribute("progressCount", issueService.countByStatus("IN_PROGRESS", adminType));
                request.setAttribute("resolvedCount", issueService.countByStatus("RESOLVED", adminType));

                request.getRequestDispatcher("/admin/issues.jsp").forward(request, response);
                break;
            }

            case "adminDetail": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/IssueServlet?action=adminList");
                    return;
                }

                int issueId = Integer.parseInt(idParam);
                Issue issue = issueService.getIssueById(issueId);

                if (issue == null) {
                    response.sendRedirect(request.getContextPath() + "/IssueServlet?action=adminList");
                    return;
                }

                request.setAttribute("issue", issue);
                request.getRequestDispatcher("/admin/issueDetails.jsp").forward(request, response);
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/IssueServlet?action=report");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        switch (action != null ? action : "") {

            case "submit": {
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));

                String category = request.getParameter("category");
                String subject = request.getParameter("subject");
                String desc = request.getParameter("description");
                String priority = request.getParameter("priority");
                String email = request.getParameter("customerEmail");
                String phone = request.getParameter("customerPhone");

                String bookingStr = request.getParameter("bookingId");
                String ticketStr = request.getParameter("ticketId");

                Integer bookingId = (bookingStr != null && !bookingStr.trim().isEmpty())
                        ? Integer.parseInt(bookingStr) : null;
                Integer ticketId = (ticketStr != null && !ticketStr.trim().isEmpty())
                        ? Integer.parseInt(ticketStr) : null;

                String assignedType = IssueService.resolveAdminType(category);

                Issue issue = new Issue(
                        userId,
                        category,
                        subject,
                        desc,
                        priority,
                        assignedType,
                        email,
                        phone,
                        bookingId,
                        ticketId
                );

                boolean ok = issueService.submitIssue(issue);

                if (ok) {
                    session.setAttribute("successMsg",
                            "Your issue has been submitted successfully. Issue ID: #" + issue.getIssueId());
                } else {
                    session.setAttribute("errorMsg",
                            "Failed to submit issue. Please try again.");
                }

                response.sendRedirect(request.getContextPath() + "/IssueServlet?action=report");
                break;
            }

            case "reply": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int issueId = Integer.parseInt(request.getParameter("issueId"));
                String message = request.getParameter("replyMessage");
                String newStatus = request.getParameter("newStatus");
                int adminId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));

                if (message != null && !message.trim().isEmpty()) {
                    IssueReply reply = new IssueReply(issueId, adminId, message.trim());
                    issueService.addReply(reply);
                }

                if (newStatus != null && !newStatus.trim().isEmpty()) {
                    issueService.updateStatus(issueId, newStatus);
                }

                response.sendRedirect(request.getContextPath()
                        + "/IssueServlet?action=adminDetail&id=" + issueId);
                break;
            }

            case "updateStatus": {
                if (!isAdmin(session)) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int issueId = Integer.parseInt(request.getParameter("issueId"));
                String status = request.getParameter("status");

                if (status != null && !status.trim().isEmpty()) {
                    issueService.updateStatus(issueId, status);
                }

                response.sendRedirect(request.getContextPath()
                        + "/IssueServlet?action=adminDetail&id=" + issueId);
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;

        Object roleObj = session.getAttribute("role");
        if (roleObj == null) return false;

        String role = String.valueOf(roleObj);
        return "ADMIN".equalsIgnoreCase(role);
    }

    private String getAdminType(HttpSession session) {
        if (session == null) return "CORE_ADMIN";

        Object permissionObj = session.getAttribute("adminPermission");
        String permission = permissionObj != null ? String.valueOf(permissionObj).toUpperCase() : "";

        if (permission.contains("FULL") || permission.contains("CORE")) return "CORE_ADMIN";
        if (permission.contains("EVENT") && permission.contains("BOOKING")) return "EVENTS_AND_BOOKINGS_ADMIN";
        if (permission.contains("EVENT")) return "EVENTS_ADMIN";
        if (permission.contains("BOOKING")) return "BOOKINGS_ADMIN";

        return "CORE_ADMIN";
    }
}