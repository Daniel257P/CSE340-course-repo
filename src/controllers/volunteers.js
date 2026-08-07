import { addVolunteer, removeVolunteer } from '../models/volunteers.js';

const processVolunteerSignup = async (req, res) => {
    const projectId = req.params.projectId;
    const userId = req.session.user.user_id;

    await addVolunteer(projectId, userId);

    req.flash('success', 'You are volunteering for this project!');
    res.redirect(`/project/${projectId}`);
};

const processVolunteerRemoval = async (req, res) => {
    const projectId = req.params.projectId;
    const userId = req.session.user.user_id;

    await removeVolunteer(projectId, userId);

    req.flash('success', 'You have been removed as a volunteer for this project.');
    // Send the user back to whichever page they clicked "remove" from
    // (the project details page or the dashboard), falling back to the dashboard.
    res.redirect(req.get('Referer') || '/dashboard');
};

export { processVolunteerSignup, processVolunteerRemoval };
