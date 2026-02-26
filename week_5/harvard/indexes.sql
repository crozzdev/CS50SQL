CREATE INDEX "enrollments_student_id" ON "enrollments" ("student_id");

CREATE INDEX "enrollments_course_id" ON "enrollments" ("course_id");

CREATE INDEX "courses_title" ON "courses" ("title");

CREATE INDEX "courses_department_name" ON "courses" ("department");

CREATE INDEX "courses_number" ON "courses" ("number");

CREATE INDEX "courses_semester" ON "courses" ("semester");

CREATE INDEX "satisfies_course_id" ON "satisfies" ("course_id");

CREATE INDEX "satisfies_requirement_id" ON "satisfies" ("requirement_id");