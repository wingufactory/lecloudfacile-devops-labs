package com.wingufactory.moodboard_backend.repository;

import com.wingufactory.moodboard_backend.model.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FeedbackRepository extends JpaRepository<Feedback, Long> {
}
