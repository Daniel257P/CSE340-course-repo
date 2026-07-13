// Import any needed model functions
import { getAllProjects } from '../models/projects.js';

const showProjectsPage = async (req, res) => {
  const projects = await getAllProjects();
  const title = 'Projects';
  
  res.render('projects', { title, projects });
};

// Export any controller functions
export { showProjectsPage };