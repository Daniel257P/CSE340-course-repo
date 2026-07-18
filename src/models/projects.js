import db from './db.js';

const getAllProjects = async () => {
  const sql = `
    SELECT 
      sp.project_id,
      sp.title,
      sp.description,
      sp.location,
      sp.date,
      o.name
    FROM service_project sp
    JOIN organization o
      ON sp.organization_id = o.organization_id
    ORDER BY sp.date;
  `;

  const result = await db.query(sql);
  return result.rows;
}

const getProjectsByOrganizationId = async (organizationId) => {
      const query = `
        SELECT
          project_id,
          organization_id,
          title,
          description,
          location,
          date
        FROM service_project
        WHERE organization_id = $1
        ORDER BY date;
      `;
      
      const queryParams = [organizationId];
      const result = await db.query(query, queryParams);

      return result.rows;
};

const getProjectsByCategoryId = async (categoryId) => {
      const query = `
        SELECT
          sp.project_id,
          sp.title,
          sp.description,
          sp.location,
          sp.date
        FROM service_project sp
        JOIN project_category pc ON sp.project_id = pc.project_id
        WHERE pc.category_id = $1
        ORDER BY sp.date;
      `;

      const queryParams = [categoryId];
      const result = await db.query(query, queryParams);

      return result.rows;
};

async function getUpcomingProjects(number_of_projects) {
  const query = `
    SELECT 
      p.project_id,
      p.title,
      p.description,
      p.date,
      p.location,
      p.organization_id,
      o.name AS organization_name
    FROM service_project p
    JOIN organization o
      ON p.organization_id = o.organization_id
    WHERE p.date >= CURRENT_DATE
    ORDER BY p.date ASC
    LIMIT $1;
  `;

  const result = await db.query(query, [number_of_projects]);
  return result.rows;
}

async function getProjectDetails(id) {
  const query = `
    SELECT 
      p.project_id,
      p.title,
      p.description,
      p.date,
      p.location,
      p.organization_id,
      o.name AS organization_name
    FROM service_project p
    JOIN organization o
      ON p.organization_id = o.organization_id
    WHERE p.project_id = $1;
  `;

  const result = await db.query(query, [id]);
  return result.rows[0]; // single project
}

// Export the model functions
export { getAllProjects, getProjectsByOrganizationId, getProjectsByCategoryId, getUpcomingProjects, getProjectDetails };