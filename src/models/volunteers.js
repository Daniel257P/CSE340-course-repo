import db from './db.js'

const addVolunteer = async (projectId, userId) => {
    const query = `
        INSERT INTO project_volunteer (project_id, user_id)
        VALUES ($1, $2);
    `;

    await db.query(query, [projectId, userId]);
}

const removeVolunteer = async (projectId, userId) => {
    const query = `
        DELETE FROM project_volunteer
        WHERE project_id = $1 AND user_id = $2;
    `;

    await db.query(query, [projectId, userId]);
}

const isUserVolunteering = async (projectId, userId) => {
    const query = `
        SELECT 1
        FROM project_volunteer
        WHERE project_id = $1 AND user_id = $2;
    `;

    const result = await db.query(query, [projectId, userId]);

    return result.rows.length > 0;
}

const getVolunteeredProjectsByUserId = async (userId) => {
    const query = `
        SELECT
            sp.project_id,
            sp.title,
            sp.description,
            sp.location,
            sp.date,
            o.name AS organization_name
        FROM project_volunteer pv
        JOIN service_project sp ON pv.project_id = sp.project_id
        JOIN organization o ON sp.organization_id = o.organization_id
        WHERE pv.user_id = $1
        ORDER BY sp.date;
    `;

    const result = await db.query(query, [userId]);

    return result.rows;
}

export { addVolunteer, removeVolunteer, isUserVolunteering, getVolunteeredProjectsByUserId };
