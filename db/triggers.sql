CREATE TRIGGER update_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON review
FOR EACH ROW
EXECUTE FUNCTION update_movie_rating();

CREATE TRIGGER restrict_short_membership_trigger
BEFORE INSERT OR UPDATE ON member
FOR EACH ROW
EXECUTE FUNCTION restrict_short_membership_trigger_func();

CREATE TRIGGER restrict_past_meetings_trigger
BEFORE INSERT OR UPDATE ON meeting
FOR EACH ROW
EXECUTE FUNCTION restrict_past_meetings();
