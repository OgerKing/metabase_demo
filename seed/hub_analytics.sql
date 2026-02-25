--
-- PostgreSQL database dump
--

\restrict Qu2LmmGII1mu6OzqYXfos3rWVFwXecE1gjYrAPdVFULrTIaVS7FTePi2x0bgGim

-- Dumped from database version 16.12
-- Dumped by pg_dump version 16.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: analytics; Type: SCHEMA; Schema: -; Owner: apiary
--

CREATE SCHEMA analytics;


ALTER SCHEMA analytics OWNER TO apiary;

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: apiary
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO apiary;

--
-- Name: demo; Type: SCHEMA; Schema: -; Owner: apiary
--

CREATE SCHEMA demo;


ALTER SCHEMA demo OWNER TO apiary;

--
-- Name: contributor_profiles_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.contributor_profiles_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO contributor_profiles_history (
      person_id, contributor_type, effective_from, effective_to,
      attribution_consent, contact_for_opportunities, terms_version,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.contributor_type, NEW.effective_from, NEW.effective_to,
      NEW.attribution_consent, NEW.contact_for_opportunities, NEW.terms_version,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE contributor_profiles_history
    SET valid_to = now()
    WHERE person_id = OLD.person_id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO contributor_profiles_history (
      person_id, contributor_type, effective_from, effective_to,
      attribution_consent, contact_for_opportunities, terms_version,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.contributor_type, NEW.effective_from, NEW.effective_to,
      NEW.attribution_consent, NEW.contact_for_opportunities, NEW.terms_version,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.contributor_profiles_history_trigger_fn() OWNER TO apiary;

--
-- Name: entitlements_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.entitlements_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO entitlements_history (
      id, person_id, product_id, organization_id, membership_pool_id, origin_person_id, origin_organization_id,
      status, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.person_id, NEW.product_id, NEW.organization_id, NEW.membership_pool_id, NEW.origin_person_id, NEW.origin_organization_id,
      NEW.status, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE entitlements_history
    SET valid_to = now()
    WHERE id = OLD.id AND valid_to = 'infinity'::timestamptz;

    INSERT INTO entitlements_history (
      id, person_id, product_id, organization_id, membership_pool_id, origin_person_id, origin_organization_id,
      status, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.person_id, NEW.product_id, NEW.organization_id, NEW.membership_pool_id, NEW.origin_person_id, NEW.origin_organization_id,
      NEW.status, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.entitlements_history_trigger_fn() OWNER TO apiary;

--
-- Name: memberships_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.memberships_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO memberships_history (
      id, person_id, organization_id, name, status, expires_at, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.person_id, NEW.organization_id, NEW.name, NEW.status, NEW.expires_at, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE memberships_history SET valid_to = now() WHERE id = OLD.id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO memberships_history (
      id, person_id, organization_id, name, status, expires_at, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.person_id, NEW.organization_id, NEW.name, NEW.status, NEW.expires_at, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.memberships_history_trigger_fn() OWNER TO apiary;

--
-- Name: organization_membership_pools_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.organization_membership_pools_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO organization_membership_pools_history (
      id, organization_id, product_id, total_seats, status, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.organization_id, NEW.product_id, NEW.total_seats, NEW.status, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE organization_membership_pools_history
    SET valid_to = now()
    WHERE id = OLD.id AND valid_to = 'infinity'::timestamptz;

    INSERT INTO organization_membership_pools_history (
      id, organization_id, product_id, total_seats, status, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.organization_id, NEW.product_id, NEW.total_seats, NEW.status, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.organization_membership_pools_history_trigger_fn() OWNER TO apiary;

--
-- Name: organizations_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.organizations_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO organizations_history (
      id, name, category, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.name, NEW.category, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE organizations_history SET valid_to = now() WHERE id = OLD.id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO organizations_history (
      id, name, category, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.name, NEW.category, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.organizations_history_trigger_fn() OWNER TO apiary;

--
-- Name: person_entitlements_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.person_entitlements_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO person_entitlements_history (
      person_id, entitlement_id, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.entitlement_id, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE person_entitlements_history
    SET valid_to = now()
    WHERE person_id = OLD.person_id AND entitlement_id = OLD.entitlement_id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO person_entitlements_history (
      person_id, entitlement_id, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.entitlement_id, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.person_entitlements_history_trigger_fn() OWNER TO apiary;

--
-- Name: person_memberships_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.person_memberships_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO person_memberships_history (
      person_id, membership_id, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.membership_id, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE person_memberships_history
    SET valid_to = now()
    WHERE person_id = OLD.person_id AND membership_id = OLD.membership_id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO person_memberships_history (
      person_id, membership_id, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.membership_id, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.person_memberships_history_trigger_fn() OWNER TO apiary;

--
-- Name: person_organizations_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.person_organizations_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO person_organizations_history (
      person_id, organization_id, role, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.organization_id, NEW.role, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE person_organizations_history
    SET valid_to = now()
    WHERE person_id = OLD.person_id AND organization_id = OLD.organization_id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO person_organizations_history (
      person_id, organization_id, role, effective_from, effective_to,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.person_id, NEW.organization_id, NEW.role, NEW.effective_from, NEW.effective_to,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.person_organizations_history_trigger_fn() OWNER TO apiary;

--
-- Name: persons_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.persons_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO persons_history (
      id, email, cognito_sub, salesforce_contact_id, medusa_customer_id, cvent_contact_id, camp_contact_id, netsuite_entity_id,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.email, NEW.cognito_sub, NEW.salesforce_contact_id, NEW.medusa_customer_id, NEW.cvent_contact_id, NEW.camp_contact_id, NEW.netsuite_entity_id,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE persons_history SET valid_to = now() WHERE id = OLD.id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO persons_history (
      id, email, cognito_sub, salesforce_contact_id, medusa_customer_id, cvent_contact_id, camp_contact_id, netsuite_entity_id,
      version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.email, NEW.cognito_sub, NEW.salesforce_contact_id, NEW.medusa_customer_id, NEW.cvent_contact_id, NEW.camp_contact_id, NEW.netsuite_entity_id,
      NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.persons_history_trigger_fn() OWNER TO apiary;

--
-- Name: products_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: apiary
--

CREATE FUNCTION public.products_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO products_history (
      id, sku, name, description, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.sku, NEW.name, NEW.description, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      NEW.created_at, 'infinity'::timestamptz, NEW.created_by_id, NEW.created_via
    );
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE products_history SET valid_to = now() WHERE id = OLD.id AND valid_to = 'infinity'::timestamptz;
    INSERT INTO products_history (
      id, sku, name, description, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via,
      valid_from, valid_to, changed_by_id, changed_via
    ) VALUES (
      NEW.id, NEW.sku, NEW.name, NEW.description, NEW.version, NEW.created_at, NEW.updated_at, NEW.created_by_id, NEW.created_via, NEW.updated_by_id, NEW.updated_via,
      now(), 'infinity'::timestamptz, NEW.updated_by_id, NEW.updated_via
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.products_history_trigger_fn() OWNER TO apiary;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: membership_plans; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.membership_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    billing_interval text NOT NULL,
    price_cents integer NOT NULL,
    currency text DEFAULT 'usd'::text NOT NULL,
    stripe_price_id text,
    status text DEFAULT 'active'::text NOT NULL,
    is_organization_level boolean DEFAULT false NOT NULL,
    trial_days integer,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    CONSTRAINT membership_plans_price_cents_check CHECK ((price_cents >= 0)),
    CONSTRAINT membership_plans_trial_days_check CHECK (((trial_days IS NULL) OR (trial_days >= 0)))
);


ALTER TABLE public.membership_plans OWNER TO apiary;

--
-- Name: TABLE membership_plans; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON TABLE public.membership_plans IS 'Logical membership plans keyed to products, with billing and Stripe price metadata.';


--
-- Name: COLUMN membership_plans.product_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.membership_plans.product_id IS 'FK to products; membership plans are a pricing/billing view over the Hub product catalog.';


--
-- Name: COLUMN membership_plans.code; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.membership_plans.code IS 'Stable business identifier for the plan (e.g., pro_annual, org_seat_monthly).';


--
-- Name: COLUMN membership_plans.billing_interval; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.membership_plans.billing_interval IS 'Billing interval for the plan: month, year, one_time, or other business-defined codes.';


--
-- Name: COLUMN membership_plans.price_cents; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.membership_plans.price_cents IS 'Price in minor currency units (e.g., cents) for the interval.';


--
-- Name: COLUMN membership_plans.stripe_price_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.membership_plans.stripe_price_id IS 'Stripe Price ID backing this membership plan, if Stripe is the billing engine.';


--
-- Name: COLUMN membership_plans.is_organization_level; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.membership_plans.is_organization_level IS 'TRUE when the plan is purchased at the organization level (seat pools), FALSE for individual plans.';


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    membership_plan_id uuid NOT NULL,
    person_id uuid,
    organization_id uuid,
    scope_type text NOT NULL,
    status text NOT NULL,
    stripe_subscription_id text,
    stripe_customer_id text,
    current_period_start timestamp with time zone,
    current_period_end timestamp with time zone,
    cancel_at_period_end boolean DEFAULT false NOT NULL,
    canceled_at timestamp with time zone,
    trial_end timestamp with time zone,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    CONSTRAINT subscriptions_check CHECK (((person_id IS NOT NULL) OR (organization_id IS NOT NULL)))
);


ALTER TABLE public.subscriptions OWNER TO apiary;

--
-- Name: TABLE subscriptions; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON TABLE public.subscriptions IS 'Pelcro-style membership subscriptions for persons or organizations, backed by Stripe or another billing engine.';


--
-- Name: COLUMN subscriptions.membership_plan_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.subscriptions.membership_plan_id IS 'FK to membership_plans representing the product/plan purchased by this subscription.';


--
-- Name: COLUMN subscriptions.person_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.subscriptions.person_id IS 'Person-level subscription owner when scope_type = person.';


--
-- Name: COLUMN subscriptions.organization_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.subscriptions.organization_id IS 'Organization-level subscription owner when scope_type = organization.';


--
-- Name: COLUMN subscriptions.scope_type; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.subscriptions.scope_type IS 'Scope of the subscription: person or organization; used alongside person_id/organization_id.';


--
-- Name: COLUMN subscriptions.status; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.subscriptions.status IS 'Lifecycle status of the subscription: trialing, active, past_due, canceled, etc.';


--
-- Name: COLUMN subscriptions.stripe_subscription_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.subscriptions.stripe_subscription_id IS 'Stripe subscription ID for this record when Stripe is used as the billing engine.';


--
-- Name: COLUMN subscriptions.stripe_customer_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.subscriptions.stripe_customer_id IS 'Stripe customer ID used for billing this subscription (denormalized for convenience).';


--
-- Name: active_members_by_plan_month; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.active_members_by_plan_month AS
 WITH active_in_month AS (
         SELECT s.membership_plan_id,
            s.person_id,
            (date_trunc('month'::text, gs.month_ts))::date AS month
           FROM (public.subscriptions s
             CROSS JOIN LATERAL ( SELECT gs_1.month_ts
                   FROM generate_series((date_trunc('month'::text, GREATEST(s.created_at, COALESCE(s.current_period_start, s.created_at))))::timestamp without time zone, (date_trunc('month'::text, LEAST(COALESCE(s.current_period_end, now()), now())))::timestamp without time zone, '1 mon'::interval) gs_1(month_ts)) gs)
          WHERE ((s.person_id IS NOT NULL) AND (s.status = ANY (ARRAY['trialing'::text, 'active'::text])))
        )
 SELECT mp.id AS membership_plan_id,
    mp.code AS plan_code,
    mp.name AS plan_name,
    mp.billing_interval,
    aim.month,
    count(DISTINCT aim.person_id) AS active_member_count
   FROM (active_in_month aim
     JOIN public.membership_plans mp ON ((mp.id = aim.membership_plan_id)))
  WHERE (mp.status = 'active'::text)
  GROUP BY mp.id, mp.code, mp.name, mp.billing_interval, aim.month
  ORDER BY mp.name, aim.month;


ALTER VIEW analytics.active_members_by_plan_month OWNER TO apiary;

--
-- Name: VIEW active_members_by_plan_month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.active_members_by_plan_month IS 'Count of distinct active (trialing/active) subscribers per membership plan per calendar month.';


--
-- Name: COLUMN active_members_by_plan_month.membership_plan_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_plan_month.membership_plan_id IS 'Hub membership_plans primary key (UUID).';


--
-- Name: COLUMN active_members_by_plan_month.plan_code; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_plan_month.plan_code IS 'Stable plan identifier (e.g. pro_annual).';


--
-- Name: COLUMN active_members_by_plan_month.plan_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_plan_month.plan_name IS 'Display name of the membership plan.';


--
-- Name: COLUMN active_members_by_plan_month.billing_interval; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_plan_month.billing_interval IS 'Billing interval for the plan (month, year, etc.).';


--
-- Name: COLUMN active_members_by_plan_month.month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_plan_month.month IS 'Calendar month (first day of month) for the time-series grain.';


--
-- Name: COLUMN active_members_by_plan_month.active_member_count; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_plan_month.active_member_count IS 'Distinct count of persons with an active or trialing subscription in this plan in this month.';


--
-- Name: entitlements; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.entitlements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid,
    product_id uuid,
    status text DEFAULT 'active'::text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    organization_id uuid,
    source text,
    membership_pool_id uuid,
    origin_person_id uuid,
    origin_organization_id uuid,
    CONSTRAINT entitlements_person_or_org_required CHECK (((person_id IS NOT NULL) OR (organization_id IS NOT NULL)))
);


ALTER TABLE public.entitlements OWNER TO apiary;

--
-- Name: COLUMN entitlements.source; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.entitlements.source IS 'Origin of entitlement: null or purchase, contributor (comp/discount), etc.';


--
-- Name: COLUMN entitlements.membership_pool_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.entitlements.membership_pool_id IS 'Optional foreign key to organization_membership_pools when this entitlement draws from an organization membership pool.';


--
-- Name: COLUMN entitlements.origin_person_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.entitlements.origin_person_id IS 'First person to whom this entitlement was allocated; does not change on reallocation.';


--
-- Name: COLUMN entitlements.origin_organization_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.entitlements.origin_organization_id IS 'Organization that originally owned this entitlement when it was created.';


--
-- Name: person_entitlements; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.person_entitlements (
    person_id uuid NOT NULL,
    entitlement_id uuid NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text
);


ALTER TABLE public.person_entitlements OWNER TO apiary;

--
-- Name: products; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sku text,
    name text,
    description text,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    category text
);


ALTER TABLE public.products OWNER TO apiary;

--
-- Name: COLUMN products.category; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.products.category IS 'Product category, e.g. contributor_benefit for comp/discount catalog.';


--
-- Name: active_members_by_product_month; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.active_members_by_product_month AS
 WITH entitlement_persons AS (
         SELECT e.id AS entitlement_id,
            COALESCE(e.person_id, pe.person_id) AS person_id,
            e.product_id,
            e.status,
            e.created_at
           FROM (public.entitlements e
             LEFT JOIN public.person_entitlements pe ON ((pe.entitlement_id = e.id)))
        )
 SELECT pr.id AS product_id,
    pr.sku AS product_sku,
    pr.name AS product_name,
    (date_trunc('month'::text, ep.created_at))::date AS month,
    count(DISTINCT ep.person_id) AS active_member_count
   FROM (entitlement_persons ep
     JOIN public.products pr ON ((pr.id = ep.product_id)))
  WHERE ((ep.person_id IS NOT NULL) AND (ep.status = 'active'::text))
  GROUP BY pr.id, pr.sku, pr.name, (date_trunc('month'::text, ep.created_at))
  ORDER BY pr.name, ((date_trunc('month'::text, ep.created_at))::date);


ALTER VIEW analytics.active_members_by_product_month OWNER TO apiary;

--
-- Name: VIEW active_members_by_product_month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.active_members_by_product_month IS 'Counts of distinct active members per product per calendar month, based on entitlements.';


--
-- Name: COLUMN active_members_by_product_month.product_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_product_month.product_id IS 'Hub product primary key (UUID) for the entitlement product.';


--
-- Name: COLUMN active_members_by_product_month.product_sku; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_product_month.product_sku IS 'Product SKU from the canonical products table.';


--
-- Name: COLUMN active_members_by_product_month.product_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_product_month.product_name IS 'Human-readable product name from the canonical products table.';


--
-- Name: COLUMN active_members_by_product_month.month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_product_month.month IS 'Calendar month (date truncated to month) when the entitlement was created.';


--
-- Name: COLUMN active_members_by_product_month.active_member_count; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.active_members_by_product_month.active_member_count IS 'Distinct count of members with active entitlements for the product in the given month.';


--
-- Name: certification_records; Type: TABLE; Schema: demo; Owner: apiary
--

CREATE TABLE demo.certification_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    certification_code text NOT NULL,
    certification_name text NOT NULL,
    training_method text NOT NULL,
    passed_at timestamp with time zone NOT NULL,
    score_pct integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT certification_records_training_method_check CHECK ((training_method = ANY (ARRAY['online'::text, 'in_person'::text, 'hybrid'::text])))
);


ALTER TABLE demo.certification_records OWNER TO apiary;

--
-- Name: TABLE certification_records; Type: COMMENT; Schema: demo; Owner: apiary
--

COMMENT ON TABLE demo.certification_records IS 'Mock certification data for demo; links to Hub person_id.';


--
-- Name: COLUMN certification_records.training_method; Type: COMMENT; Schema: demo; Owner: apiary
--

COMMENT ON COLUMN demo.certification_records.training_method IS 'online | in_person | hybrid for pass-rate by method.';


--
-- Name: certification_pass_rates_by_method; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.certification_pass_rates_by_method AS
 SELECT training_method,
    (date_trunc('month'::text, passed_at))::date AS month,
    count(*) AS passed_count,
    count(*) FILTER (WHERE (score_pct IS NOT NULL)) AS scored_count,
    round(avg(score_pct) FILTER (WHERE (score_pct IS NOT NULL)), 1) AS avg_score_pct
   FROM demo.certification_records c
  GROUP BY training_method, (date_trunc('month'::text, passed_at))
  ORDER BY training_method, ((date_trunc('month'::text, passed_at))::date);


ALTER VIEW analytics.certification_pass_rates_by_method OWNER TO apiary;

--
-- Name: VIEW certification_pass_rates_by_method; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.certification_pass_rates_by_method IS 'Demo: certification pass counts and average score by training method (online vs in_person) and month.';


--
-- Name: COLUMN certification_pass_rates_by_method.training_method; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.certification_pass_rates_by_method.training_method IS 'Training method: online, in_person, or hybrid.';


--
-- Name: COLUMN certification_pass_rates_by_method.passed_count; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.certification_pass_rates_by_method.passed_count IS 'Number of certifications passed in the month for this method.';


--
-- Name: big_commerce_orders; Type: TABLE; Schema: demo; Owner: apiary
--

CREATE TABLE demo.big_commerce_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid,
    order_id text NOT NULL,
    total_cents bigint NOT NULL,
    channel text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE demo.big_commerce_orders OWNER TO apiary;

--
-- Name: TABLE big_commerce_orders; Type: COMMENT; Schema: demo; Owner: apiary
--

COMMENT ON TABLE demo.big_commerce_orders IS 'Mock Big Commerce order data for attribution / revenue demo.';


--
-- Name: linkedin_profiles; Type: TABLE; Schema: demo; Owner: apiary
--

CREATE TABLE demo.linkedin_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    linkedin_id text NOT NULL,
    headline text,
    connections_count integer,
    last_synced_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE demo.linkedin_profiles OWNER TO apiary;

--
-- Name: TABLE linkedin_profiles; Type: COMMENT; Schema: demo; Owner: apiary
--

COMMENT ON TABLE demo.linkedin_profiles IS 'Mock LinkedIn profile data for demo; one-to-one with Hub person.';


--
-- Name: salesforce_contacts; Type: TABLE; Schema: demo; Owner: apiary
--

CREATE TABLE demo.salesforce_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid,
    salesforce_id text NOT NULL,
    email text NOT NULL,
    company_name text,
    lead_source text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE demo.salesforce_contacts OWNER TO apiary;

--
-- Name: TABLE salesforce_contacts; Type: COMMENT; Schema: demo; Owner: apiary
--

COMMENT ON TABLE demo.salesforce_contacts IS 'Mock Salesforce contact data; person_id links to Hub.';


--
-- Name: salesforce_opportunities; Type: TABLE; Schema: demo; Owner: apiary
--

CREATE TABLE demo.salesforce_opportunities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contact_id uuid NOT NULL,
    name text,
    amount_cents bigint,
    stage text NOT NULL,
    closed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE demo.salesforce_opportunities OWNER TO apiary;

--
-- Name: TABLE salesforce_opportunities; Type: COMMENT; Schema: demo; Owner: apiary
--

COMMENT ON TABLE demo.salesforce_opportunities IS 'Mock Salesforce opportunities for attribution/revenue demo.';


--
-- Name: persons; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.persons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text,
    cognito_sub text,
    salesforce_contact_id text,
    medusa_customer_id text,
    cvent_contact_id text,
    camp_contact_id text,
    netsuite_entity_id text,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    stripe_customer_id text
);


ALTER TABLE public.persons OWNER TO apiary;

--
-- Name: COLUMN persons.stripe_customer_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.persons.stripe_customer_id IS 'Stripe customer ID for this person (individual billing context).';


--
-- Name: demo_member_360; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.demo_member_360 AS
 SELECT p.id AS person_id,
    p.email,
    p.created_at AS person_created_at,
    ( SELECT count(*) AS count
           FROM demo.certification_records c
          WHERE (c.person_id = p.id)) AS certification_count,
    ( SELECT count(*) AS count
           FROM (demo.salesforce_opportunities o
             JOIN demo.salesforce_contacts sc ON ((sc.id = o.contact_id)))
          WHERE (sc.person_id = p.id)) AS salesforce_opportunity_count,
    ( SELECT COALESCE(sum(o.amount_cents), (0)::numeric) AS "coalesce"
           FROM (demo.salesforce_opportunities o
             JOIN demo.salesforce_contacts sc ON ((sc.id = o.contact_id)))
          WHERE (sc.person_id = p.id)) AS salesforce_pipeline_cents,
    lp.headline AS linkedin_headline,
    lp.connections_count AS linkedin_connections,
    ( SELECT count(*) AS count
           FROM demo.big_commerce_orders b
          WHERE (b.person_id = p.id)) AS big_commerce_order_count,
    ( SELECT COALESCE(sum(b.total_cents), (0)::numeric) AS "coalesce"
           FROM demo.big_commerce_orders b
          WHERE (b.person_id = p.id)) AS big_commerce_total_cents
   FROM (public.persons p
     LEFT JOIN demo.linkedin_profiles lp ON ((lp.person_id = p.id)))
  ORDER BY p.email;


ALTER VIEW analytics.demo_member_360 OWNER TO apiary;

--
-- Name: VIEW demo_member_360; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.demo_member_360 IS 'Demo: unified member view with Hub person + certification count, Salesforce pipeline, LinkedIn, Big Commerce.';


--
-- Name: COLUMN demo_member_360.salesforce_pipeline_cents; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.demo_member_360.salesforce_pipeline_cents IS 'Total opportunity amount (cents) from mock Salesforce for this person.';


--
-- Name: COLUMN demo_member_360.big_commerce_total_cents; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.demo_member_360.big_commerce_total_cents IS 'Total order value (cents) from mock Big Commerce for this person.';


--
-- Name: demo_revenue_by_channel; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.demo_revenue_by_channel AS
 SELECT channel,
    (date_trunc('month'::text, created_at))::date AS month,
    count(*) AS order_count,
    sum(total_cents) AS total_cents
   FROM demo.big_commerce_orders b
  GROUP BY channel, (date_trunc('month'::text, created_at))
  ORDER BY channel, ((date_trunc('month'::text, created_at))::date);


ALTER VIEW analytics.demo_revenue_by_channel OWNER TO apiary;

--
-- Name: VIEW demo_revenue_by_channel; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.demo_revenue_by_channel IS 'Demo: mock Big Commerce order count and revenue by channel and month (for attribution dashboards).';


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    category text,
    stripe_customer_id text
);


ALTER TABLE public.organizations OWNER TO apiary;

--
-- Name: COLUMN organizations.category; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organizations.category IS 'Optional category, e.g. seed for seed data, fortune500, college.';


--
-- Name: COLUMN organizations.stripe_customer_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organizations.stripe_customer_id IS 'Stripe customer ID for this organization (account-level billing context).';


--
-- Name: entitlements_by_channel; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.entitlements_by_channel AS
 SELECT e.source AS channel,
    (date_trunc('month'::text, e.created_at))::date AS month,
    pr.id AS product_id,
    pr.sku AS product_sku,
    pr.name AS product_name,
    org.id AS organization_id,
    org.name AS organization_name,
    org.category AS organization_category,
    count(*) AS total_entitlements,
    count(*) FILTER (WHERE (e.status = 'active'::text)) AS active_entitlements
   FROM ((public.entitlements e
     LEFT JOIN public.products pr ON ((pr.id = e.product_id)))
     LEFT JOIN public.organizations org ON ((org.id = e.organization_id)))
  GROUP BY e.source, (date_trunc('month'::text, e.created_at)), pr.id, pr.sku, pr.name, org.id, org.name, org.category
  ORDER BY e.source, ((date_trunc('month'::text, e.created_at))::date), pr.name, org.name;


ALTER VIEW analytics.entitlements_by_channel OWNER TO apiary;

--
-- Name: VIEW entitlements_by_channel; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.entitlements_by_channel IS 'Entitlement volume by source channel, product, organization, and calendar month.';


--
-- Name: COLUMN entitlements_by_channel.channel; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.channel IS 'Entitlement source channel (e.g. purchase, contributor, migration) from entitlements.source.';


--
-- Name: COLUMN entitlements_by_channel.month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.month IS 'Calendar month (date truncated to month) when the entitlement was created.';


--
-- Name: COLUMN entitlements_by_channel.product_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.product_id IS 'Hub product primary key (UUID) for the entitlement product.';


--
-- Name: COLUMN entitlements_by_channel.product_sku; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.product_sku IS 'Product SKU from the canonical products table.';


--
-- Name: COLUMN entitlements_by_channel.product_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.product_name IS 'Human-readable product name from the canonical products table.';


--
-- Name: COLUMN entitlements_by_channel.organization_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.organization_id IS 'Organization receiving the entitlement (if any).';


--
-- Name: COLUMN entitlements_by_channel.organization_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.organization_name IS 'Organization name for the entitlement (if any).';


--
-- Name: COLUMN entitlements_by_channel.organization_category; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.organization_category IS 'Organization category (e.g. seed, fortune500, college) for analytics segmentation.';


--
-- Name: COLUMN entitlements_by_channel.total_entitlements; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.total_entitlements IS 'Total entitlement rows created for the channel/product/organization/month.';


--
-- Name: COLUMN entitlements_by_channel.active_entitlements; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.entitlements_by_channel.active_entitlements IS 'Entitlements with status = active for the channel/product/organization/month.';


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subscription_id uuid,
    person_id uuid,
    organization_id uuid,
    stripe_invoice_id text,
    stripe_invoice_number text,
    hosted_invoice_url text,
    invoice_pdf_url text,
    status text NOT NULL,
    amount_due_cents integer NOT NULL,
    amount_paid_cents integer,
    currency text DEFAULT 'usd'::text NOT NULL,
    period_start timestamp with time zone,
    period_end timestamp with time zone,
    due_date timestamp with time zone,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    CONSTRAINT invoices_amount_due_cents_check CHECK ((amount_due_cents >= 0)),
    CONSTRAINT invoices_amount_paid_cents_check CHECK (((amount_paid_cents IS NULL) OR (amount_paid_cents >= 0)))
);


ALTER TABLE public.invoices OWNER TO apiary;

--
-- Name: TABLE invoices; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON TABLE public.invoices IS 'Shadow table for Stripe (or other billing engine) invoices, linked back to subscriptions and Hub identities.';


--
-- Name: COLUMN invoices.subscription_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.invoices.subscription_id IS 'FK to subscriptions; may be NULL for one-off invoices not tied to a recurring subscription.';


--
-- Name: COLUMN invoices.stripe_invoice_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.invoices.stripe_invoice_id IS 'Stripe invoice ID backing this record.';


--
-- Name: COLUMN invoices.hosted_invoice_url; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.invoices.hosted_invoice_url IS 'Hosted invoice URL from the billing engine for CSR/member access.';


--
-- Name: COLUMN invoices.invoice_pdf_url; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.invoices.invoice_pdf_url IS 'Direct link to a PDF representation of the invoice, when available.';


--
-- Name: member_subscription_invoice_summary; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.member_subscription_invoice_summary AS
 WITH person_subs AS (
         SELECT s.person_id,
            s.id AS subscription_id,
            s.status AS subscription_status,
            s.current_period_end,
            s.cancel_at_period_end,
            mp.code AS plan_code,
            mp.name AS plan_name,
            mp.billing_interval,
            row_number() OVER (PARTITION BY s.person_id ORDER BY s.current_period_end DESC NULLS LAST) AS rn
           FROM (public.subscriptions s
             JOIN public.membership_plans mp ON ((mp.id = s.membership_plan_id)))
          WHERE ((s.person_id IS NOT NULL) AND (s.status = ANY (ARRAY['trialing'::text, 'active'::text, 'past_due'::text])))
        ), primary_sub AS (
         SELECT person_subs.person_id,
            person_subs.subscription_id,
            person_subs.subscription_status,
            person_subs.current_period_end,
            person_subs.cancel_at_period_end,
            person_subs.plan_code,
            person_subs.plan_name,
            person_subs.billing_interval
           FROM person_subs
          WHERE (person_subs.rn = 1)
        ), invoice_agg AS (
         SELECT invoices.person_id,
            count(*) FILTER (WHERE (invoices.status = 'paid'::text)) AS invoices_paid_count,
            COALESCE(sum(invoices.amount_paid_cents) FILTER (WHERE (invoices.status = 'paid'::text)), (0)::bigint) AS total_paid_cents,
            max(invoices.created_at) FILTER (WHERE (invoices.status = 'paid'::text)) AS last_paid_invoice_at
           FROM public.invoices
          WHERE (invoices.person_id IS NOT NULL)
          GROUP BY invoices.person_id
        )
 SELECT p.id AS person_id,
    p.email,
    ps.plan_code AS primary_plan_code,
    ps.plan_name AS primary_plan_name,
    ps.billing_interval AS primary_plan_interval,
    ps.subscription_status AS primary_subscription_status,
    ps.current_period_end AS primary_current_period_end,
    ps.cancel_at_period_end AS primary_cancel_at_period_end,
    ( SELECT count(*) AS count
           FROM public.subscriptions s2
          WHERE ((s2.person_id = p.id) AND (s2.status = ANY (ARRAY['trialing'::text, 'active'::text, 'past_due'::text])))) AS active_subscription_count,
    COALESCE(ia.invoices_paid_count, (0)::bigint) AS invoices_paid_count,
    COALESCE(ia.total_paid_cents, (0)::bigint) AS total_paid_cents,
    ia.last_paid_invoice_at
   FROM ((public.persons p
     LEFT JOIN primary_sub ps ON ((ps.person_id = p.id)))
     LEFT JOIN invoice_agg ia ON ((ia.person_id = p.id)))
  ORDER BY p.email;


ALTER VIEW analytics.member_subscription_invoice_summary OWNER TO apiary;

--
-- Name: VIEW member_subscription_invoice_summary; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.member_subscription_invoice_summary IS 'Per-person subscription and invoice summary for Metabase; extends Unified Member View with billing context.';


--
-- Name: COLUMN member_subscription_invoice_summary.person_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.person_id IS 'Hub person primary key (UUID). Join key for linking to persons or analytics.unified_member.';


--
-- Name: COLUMN member_subscription_invoice_summary.email; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.email IS 'Person email from Hub; use for display or filters.';


--
-- Name: COLUMN member_subscription_invoice_summary.primary_plan_code; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.primary_plan_code IS 'Code of the primary (most recent period end) active subscription plan.';


--
-- Name: COLUMN member_subscription_invoice_summary.primary_plan_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.primary_plan_name IS 'Display name of the primary subscription plan.';


--
-- Name: COLUMN member_subscription_invoice_summary.primary_plan_interval; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.primary_plan_interval IS 'Billing interval of the primary plan (e.g. month, year).';


--
-- Name: COLUMN member_subscription_invoice_summary.primary_subscription_status; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.primary_subscription_status IS 'Status of the primary subscription: trialing, active, or past_due.';


--
-- Name: COLUMN member_subscription_invoice_summary.primary_current_period_end; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.primary_current_period_end IS 'End of the current billing period for the primary subscription.';


--
-- Name: COLUMN member_subscription_invoice_summary.primary_cancel_at_period_end; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.primary_cancel_at_period_end IS 'True if the primary subscription is set to cancel at period end.';


--
-- Name: COLUMN member_subscription_invoice_summary.active_subscription_count; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.active_subscription_count IS 'Count of person-level subscriptions in trialing, active, or past_due status.';


--
-- Name: COLUMN member_subscription_invoice_summary.invoices_paid_count; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.invoices_paid_count IS 'Count of paid invoices for this person.';


--
-- Name: COLUMN member_subscription_invoice_summary.total_paid_cents; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.total_paid_cents IS 'Sum of amount_paid_cents across all paid invoices for this person.';


--
-- Name: COLUMN member_subscription_invoice_summary.last_paid_invoice_at; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.member_subscription_invoice_summary.last_paid_invoice_at IS 'Timestamp of the most recent paid invoice.';


--
-- Name: mv_active_members_by_product_month; Type: MATERIALIZED VIEW; Schema: analytics; Owner: apiary
--

CREATE MATERIALIZED VIEW analytics.mv_active_members_by_product_month AS
 WITH entitlement_persons AS (
         SELECT e.id AS entitlement_id,
            COALESCE(e.person_id, pe.person_id) AS person_id,
            e.product_id,
            e.status,
            e.created_at
           FROM (public.entitlements e
             LEFT JOIN public.person_entitlements pe ON ((pe.entitlement_id = e.id)))
        )
 SELECT pr.id AS product_id,
    pr.sku AS product_sku,
    pr.name AS product_name,
    (date_trunc('month'::text, ep.created_at))::date AS month,
    count(DISTINCT ep.person_id) AS active_member_count
   FROM (entitlement_persons ep
     JOIN public.products pr ON ((pr.id = ep.product_id)))
  WHERE ((ep.person_id IS NOT NULL) AND (ep.status = 'active'::text))
  GROUP BY pr.id, pr.sku, pr.name, (date_trunc('month'::text, ep.created_at))
  ORDER BY pr.name, ((date_trunc('month'::text, ep.created_at))::date)
  WITH NO DATA;


ALTER MATERIALIZED VIEW analytics.mv_active_members_by_product_month OWNER TO apiary;

--
-- Name: MATERIALIZED VIEW mv_active_members_by_product_month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON MATERIALIZED VIEW analytics.mv_active_members_by_product_month IS 'Cached snapshot for demo: active members per product per month. Refresh after seed.';


--
-- Name: mv_entitlements_by_channel; Type: MATERIALIZED VIEW; Schema: analytics; Owner: apiary
--

CREATE MATERIALIZED VIEW analytics.mv_entitlements_by_channel AS
 SELECT e.source AS channel,
    (date_trunc('month'::text, e.created_at))::date AS month,
    pr.id AS product_id,
    pr.sku AS product_sku,
    pr.name AS product_name,
    org.id AS organization_id,
    org.name AS organization_name,
    org.category AS organization_category,
    count(*) AS total_entitlements,
    count(*) FILTER (WHERE (e.status = 'active'::text)) AS active_entitlements
   FROM ((public.entitlements e
     LEFT JOIN public.products pr ON ((pr.id = e.product_id)))
     LEFT JOIN public.organizations org ON ((org.id = e.organization_id)))
  GROUP BY e.source, (date_trunc('month'::text, e.created_at)), pr.id, pr.sku, pr.name, org.id, org.name, org.category
  ORDER BY e.source, ((date_trunc('month'::text, e.created_at))::date), pr.name, org.name
  WITH NO DATA;


ALTER MATERIALIZED VIEW analytics.mv_entitlements_by_channel OWNER TO apiary;

--
-- Name: MATERIALIZED VIEW mv_entitlements_by_channel; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON MATERIALIZED VIEW analytics.mv_entitlements_by_channel IS 'Cached snapshot for demo: entitlement volume by channel, product, org, month. Refresh after seed.';


--
-- Name: organization_membership_pools; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.organization_membership_pools (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    product_id uuid NOT NULL,
    total_seats integer NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    CONSTRAINT organization_membership_pools_total_seats_check CHECK ((total_seats >= 0))
);


ALTER TABLE public.organization_membership_pools OWNER TO apiary;

--
-- Name: TABLE organization_membership_pools; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON TABLE public.organization_membership_pools IS 'Organization-level membership seat pools keyed by organization and product.';


--
-- Name: COLUMN organization_membership_pools.total_seats; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_membership_pools.total_seats IS 'Total membership seats purchased/allocated at the organization+product level.';


--
-- Name: COLUMN organization_membership_pools.status; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_membership_pools.status IS 'Lifecycle status of the pool: active, suspended, cancelled, expired.';


--
-- Name: mv_organization_membership_pools; Type: MATERIALIZED VIEW; Schema: analytics; Owner: apiary
--

CREATE MATERIALIZED VIEW analytics.mv_organization_membership_pools AS
 WITH pools AS (
         SELECT omp.id AS pool_id,
            omp.organization_id,
            omp.product_id,
            omp.total_seats,
            omp.status
           FROM public.organization_membership_pools omp
          WHERE (omp.status = 'active'::text)
        ), pool_entitlements AS (
         SELECT p_1.pool_id,
            e.id AS entitlement_id
           FROM (pools p_1
             LEFT JOIN public.entitlements e ON (((e.membership_pool_id = p_1.pool_id) AND (e.status = 'active'::text))))
        ), allocated_seats AS (
         SELECT pe.pool_id,
            count(DISTINCT pe.entitlement_id) AS seats_allocated
           FROM pool_entitlements pe
          GROUP BY pe.pool_id
        )
 SELECT org.id AS organization_id,
    org.name AS organization_name,
    org.category AS organization_category,
    pr.id AS product_id,
    pr.sku AS product_sku,
    pr.name AS product_name,
    p.pool_id,
    p.total_seats,
    COALESCE(a.seats_allocated, (0)::bigint) AS seats_allocated,
    GREATEST((p.total_seats - COALESCE(a.seats_allocated, (0)::bigint)), (0)::bigint) AS seats_available
   FROM (((pools p
     JOIN public.organizations org ON ((org.id = p.organization_id)))
     LEFT JOIN public.products pr ON ((pr.id = p.product_id)))
     LEFT JOIN allocated_seats a ON ((a.pool_id = p.pool_id)))
  ORDER BY org.name, pr.name
  WITH NO DATA;


ALTER MATERIALIZED VIEW analytics.mv_organization_membership_pools OWNER TO apiary;

--
-- Name: MATERIALIZED VIEW mv_organization_membership_pools; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON MATERIALIZED VIEW analytics.mv_organization_membership_pools IS 'Cached snapshot for demo: org membership pools. Refresh after seed.';


--
-- Name: mv_organization_seat_summary; Type: MATERIALIZED VIEW; Schema: analytics; Owner: apiary
--

CREATE MATERIALIZED VIEW analytics.mv_organization_seat_summary AS
 WITH org_product_entitlements AS (
         SELECT org.id AS organization_id,
            org.name AS organization_name,
            org.category AS organization_category,
            pr.id AS product_id,
            pr.sku AS product_sku,
            pr.name AS product_name,
            e.id AS entitlement_id,
            e.status
           FROM ((public.entitlements e
             JOIN public.organizations org ON ((org.id = e.organization_id)))
             LEFT JOIN public.products pr ON ((pr.id = e.product_id)))
        ), allocated_seats AS (
         SELECT ope_1.organization_id,
            ope_1.product_id,
            count(DISTINCT pe.person_id) AS seats_allocated
           FROM (org_product_entitlements ope_1
             JOIN public.person_entitlements pe ON ((pe.entitlement_id = ope_1.entitlement_id)))
          WHERE (ope_1.status = 'active'::text)
          GROUP BY ope_1.organization_id, ope_1.product_id
        ), purchased_seats AS (
         SELECT org_product_entitlements.organization_id,
            org_product_entitlements.product_id,
            count(*) FILTER (WHERE (org_product_entitlements.status = 'active'::text)) AS seats_purchased
           FROM org_product_entitlements
          GROUP BY org_product_entitlements.organization_id, org_product_entitlements.product_id
        )
 SELECT ope.organization_id,
    ope.organization_name,
    ope.organization_category,
    ope.product_id,
    ope.product_sku,
    ope.product_name,
    COALESCE(ps.seats_purchased, (0)::bigint) AS seats_purchased,
    COALESCE(a.seats_allocated, (0)::bigint) AS seats_allocated,
    GREATEST((COALESCE(ps.seats_purchased, (0)::bigint) - COALESCE(a.seats_allocated, (0)::bigint)), (0)::bigint) AS seats_available
   FROM ((( SELECT DISTINCT org_product_entitlements.organization_id,
            org_product_entitlements.organization_name,
            org_product_entitlements.organization_category,
            org_product_entitlements.product_id,
            org_product_entitlements.product_sku,
            org_product_entitlements.product_name
           FROM org_product_entitlements) ope
     LEFT JOIN purchased_seats ps ON (((ps.organization_id = ope.organization_id) AND (ps.product_id = ope.product_id))))
     LEFT JOIN allocated_seats a ON (((a.organization_id = ope.organization_id) AND (a.product_id = ope.product_id))))
  ORDER BY ope.organization_name, ope.product_name
  WITH NO DATA;


ALTER MATERIALIZED VIEW analytics.mv_organization_seat_summary OWNER TO apiary;

--
-- Name: MATERIALIZED VIEW mv_organization_seat_summary; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON MATERIALIZED VIEW analytics.mv_organization_seat_summary IS 'Cached snapshot for demo: org seat purchased vs allocated. Refresh after seed.';


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.memberships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid,
    status text DEFAULT 'active'::text NOT NULL,
    expires_at timestamp with time zone,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    organization_id uuid,
    CONSTRAINT memberships_person_or_org_required CHECK (((person_id IS NOT NULL) OR (organization_id IS NOT NULL)))
);


ALTER TABLE public.memberships OWNER TO apiary;

--
-- Name: person_entitlements_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.person_entitlements_history (
    history_id bigint NOT NULL,
    person_id uuid NOT NULL,
    entitlement_id uuid NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.person_entitlements_history OWNER TO apiary;

--
-- Name: person_memberships; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.person_memberships (
    person_id uuid NOT NULL,
    membership_id uuid NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text
);


ALTER TABLE public.person_memberships OWNER TO apiary;

--
-- Name: person_memberships_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.person_memberships_history (
    history_id bigint NOT NULL,
    person_id uuid NOT NULL,
    membership_id uuid NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.person_memberships_history OWNER TO apiary;

--
-- Name: person_organizations; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.person_organizations (
    person_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    role text,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text
);


ALTER TABLE public.person_organizations OWNER TO apiary;

--
-- Name: person_organizations_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.person_organizations_history (
    history_id bigint NOT NULL,
    person_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    role text,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.person_organizations_history OWNER TO apiary;

--
-- Name: persons_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.persons_history (
    history_id bigint NOT NULL,
    id uuid NOT NULL,
    email text,
    cognito_sub text,
    salesforce_contact_id text,
    medusa_customer_id text,
    cvent_contact_id text,
    camp_contact_id text,
    netsuite_entity_id text,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.persons_history OWNER TO apiary;

--
-- Name: mv_unified_member; Type: MATERIALIZED VIEW; Schema: analytics; Owner: apiary
--

CREATE MATERIALIZED VIEW analytics.mv_unified_member AS
 SELECT p.id AS person_id,
    jsonb_build_object('person', to_jsonb(p.*), 'identity_map', jsonb_build_object('email', p.email, 'cognito_sub', p.cognito_sub, 'salesforce_contact_id', p.salesforce_contact_id, 'medusa_customer_id', p.medusa_customer_id, 'cvent_contact_id', p.cvent_contact_id, 'camp_contact_id', p.camp_contact_id, 'netsuite_entity_id', p.netsuite_entity_id), 'person_history', COALESCE(ph.rows, '[]'::jsonb), 'organizations', COALESCE(orgs.rows, '[]'::jsonb), 'person_organizations_history', COALESCE(poh.rows, '[]'::jsonb), 'memberships', COALESCE(mems.rows, '[]'::jsonb), 'person_memberships_history', COALESCE(pmh.rows, '[]'::jsonb), 'entitlements', COALESCE(ents.rows, '[]'::jsonb), 'person_entitlements_history', COALESCE(peh.rows, '[]'::jsonb)) AS person_document
   FROM (((((((public.persons p
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(ph_1.*))::jsonb ORDER BY ph_1.valid_from) AS rows
           FROM public.persons_history ph_1
          WHERE (ph_1.id = p.id)) ph ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg(jsonb_build_object('organization', to_jsonb(o.*), 'link', to_jsonb(po.*)) ORDER BY o.name) AS rows
           FROM (public.person_organizations po
             JOIN public.organizations o ON ((o.id = po.organization_id)))
          WHERE (po.person_id = p.id)) orgs ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(poh_1.*))::jsonb ORDER BY poh_1.valid_from) AS rows
           FROM public.person_organizations_history poh_1
          WHERE (poh_1.person_id = p.id)) poh ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg(jsonb_build_object('membership', to_jsonb(m.*), 'link', to_jsonb(pm.*)) ORDER BY m.expires_at, m.created_at) AS rows
           FROM (public.person_memberships pm
             JOIN public.memberships m ON ((m.id = pm.membership_id)))
          WHERE (pm.person_id = p.id)) mems ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(pmh_1.*))::jsonb ORDER BY pmh_1.valid_from) AS rows
           FROM public.person_memberships_history pmh_1
          WHERE (pmh_1.person_id = p.id)) pmh ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg(jsonb_build_object('entitlement', to_jsonb(e.*), 'product', to_jsonb(pr.*), 'link', to_jsonb(pe.*)) ORDER BY e.created_at) AS rows
           FROM ((public.person_entitlements pe
             JOIN public.entitlements e ON ((e.id = pe.entitlement_id)))
             LEFT JOIN public.products pr ON ((pr.id = e.product_id)))
          WHERE (pe.person_id = p.id)) ents ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(peh_1.*))::jsonb ORDER BY peh_1.valid_from) AS rows
           FROM public.person_entitlements_history peh_1
          WHERE (peh_1.person_id = p.id)) peh ON (true))
  ORDER BY p.email
  WITH NO DATA;


ALTER MATERIALIZED VIEW analytics.mv_unified_member OWNER TO apiary;

--
-- Name: MATERIALIZED VIEW mv_unified_member; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON MATERIALIZED VIEW analytics.mv_unified_member IS 'Cached unified member document for demo. Refresh after seed.';


--
-- Name: organization_membership_pools; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.organization_membership_pools AS
 WITH pools AS (
         SELECT omp.id AS pool_id,
            omp.organization_id,
            omp.product_id,
            omp.total_seats,
            omp.status
           FROM public.organization_membership_pools omp
          WHERE (omp.status = 'active'::text)
        ), pool_entitlements AS (
         SELECT p_1.pool_id,
            e.id AS entitlement_id
           FROM (pools p_1
             LEFT JOIN public.entitlements e ON (((e.membership_pool_id = p_1.pool_id) AND (e.status = 'active'::text))))
        ), allocated_seats AS (
         SELECT pe.pool_id,
            count(DISTINCT pe.entitlement_id) AS seats_allocated
           FROM pool_entitlements pe
          GROUP BY pe.pool_id
        )
 SELECT org.id AS organization_id,
    org.name AS organization_name,
    org.category AS organization_category,
    pr.id AS product_id,
    pr.sku AS product_sku,
    pr.name AS product_name,
    p.pool_id,
    p.total_seats,
    COALESCE(a.seats_allocated, (0)::bigint) AS seats_allocated,
    GREATEST((p.total_seats - COALESCE(a.seats_allocated, (0)::bigint)), (0)::bigint) AS seats_available
   FROM (((pools p
     JOIN public.organizations org ON ((org.id = p.organization_id)))
     LEFT JOIN public.products pr ON ((pr.id = p.product_id)))
     LEFT JOIN allocated_seats a ON ((a.pool_id = p.pool_id)))
  ORDER BY org.name, pr.name;


ALTER VIEW analytics.organization_membership_pools OWNER TO apiary;

--
-- Name: VIEW organization_membership_pools; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.organization_membership_pools IS 'Summary of organization membership pools, including total seats, allocated seats, and seats available.';


--
-- Name: COLUMN organization_membership_pools.organization_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.organization_id IS 'Organization primary key (UUID) that owns the membership pool.';


--
-- Name: COLUMN organization_membership_pools.organization_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.organization_name IS 'Organization name for display in dashboards.';


--
-- Name: COLUMN organization_membership_pools.organization_category; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.organization_category IS 'Organization category (e.g. seed, fortune500, college) for analytics segmentation.';


--
-- Name: COLUMN organization_membership_pools.product_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.product_id IS 'Hub product primary key (UUID) associated with the membership pool.';


--
-- Name: COLUMN organization_membership_pools.product_sku; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.product_sku IS 'Product SKU associated with the membership pool.';


--
-- Name: COLUMN organization_membership_pools.product_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.product_name IS 'Product name associated with the membership pool.';


--
-- Name: COLUMN organization_membership_pools.pool_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.pool_id IS 'Primary key of the organization_membership_pools row summarized by this record.';


--
-- Name: COLUMN organization_membership_pools.total_seats; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.total_seats IS 'Total membership seats purchased/allocated at the organization+product level for this pool.';


--
-- Name: COLUMN organization_membership_pools.seats_allocated; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.seats_allocated IS 'Count of active entitlements linked to this pool (treated as allocated seats).';


--
-- Name: COLUMN organization_membership_pools.seats_available; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_membership_pools.seats_available IS 'Pool capacity (total_seats) minus allocated seats, floored at zero.';


--
-- Name: organization_seat_summary; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.organization_seat_summary AS
 WITH org_product_entitlements AS (
         SELECT org.id AS organization_id,
            org.name AS organization_name,
            org.category AS organization_category,
            pr.id AS product_id,
            pr.sku AS product_sku,
            pr.name AS product_name,
            e.id AS entitlement_id,
            e.status
           FROM ((public.entitlements e
             JOIN public.organizations org ON ((org.id = e.organization_id)))
             LEFT JOIN public.products pr ON ((pr.id = e.product_id)))
        ), allocated_seats AS (
         SELECT ope_1.organization_id,
            ope_1.product_id,
            count(DISTINCT pe.person_id) AS seats_allocated
           FROM (org_product_entitlements ope_1
             JOIN public.person_entitlements pe ON ((pe.entitlement_id = ope_1.entitlement_id)))
          WHERE (ope_1.status = 'active'::text)
          GROUP BY ope_1.organization_id, ope_1.product_id
        ), purchased_seats AS (
         SELECT org_product_entitlements.organization_id,
            org_product_entitlements.product_id,
            count(*) FILTER (WHERE (org_product_entitlements.status = 'active'::text)) AS seats_purchased
           FROM org_product_entitlements
          GROUP BY org_product_entitlements.organization_id, org_product_entitlements.product_id
        )
 SELECT ope.organization_id,
    ope.organization_name,
    ope.organization_category,
    ope.product_id,
    ope.product_sku,
    ope.product_name,
    COALESCE(ps.seats_purchased, (0)::bigint) AS seats_purchased,
    COALESCE(a.seats_allocated, (0)::bigint) AS seats_allocated,
    GREATEST((COALESCE(ps.seats_purchased, (0)::bigint) - COALESCE(a.seats_allocated, (0)::bigint)), (0)::bigint) AS seats_available
   FROM ((( SELECT DISTINCT org_product_entitlements.organization_id,
            org_product_entitlements.organization_name,
            org_product_entitlements.organization_category,
            org_product_entitlements.product_id,
            org_product_entitlements.product_sku,
            org_product_entitlements.product_name
           FROM org_product_entitlements) ope
     LEFT JOIN purchased_seats ps ON (((ps.organization_id = ope.organization_id) AND (ps.product_id = ope.product_id))))
     LEFT JOIN allocated_seats a ON (((a.organization_id = ope.organization_id) AND (a.product_id = ope.product_id))))
  ORDER BY ope.organization_name, ope.product_name;


ALTER VIEW analytics.organization_seat_summary OWNER TO apiary;

--
-- Name: VIEW organization_seat_summary; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.organization_seat_summary IS 'Per-organization, per-product summary of seats purchased vs allocated, with remaining available seats.';


--
-- Name: COLUMN organization_seat_summary.organization_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.organization_id IS 'Organization primary key (UUID) owning the seats.';


--
-- Name: COLUMN organization_seat_summary.organization_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.organization_name IS 'Organization name for display in dashboards.';


--
-- Name: COLUMN organization_seat_summary.organization_category; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.organization_category IS 'Organization category (e.g. seed, fortune500, college) for analytics segmentation.';


--
-- Name: COLUMN organization_seat_summary.product_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.product_id IS 'Hub product primary key (UUID) associated with the seats.';


--
-- Name: COLUMN organization_seat_summary.product_sku; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.product_sku IS 'Product SKU associated with the seats.';


--
-- Name: COLUMN organization_seat_summary.product_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.product_name IS 'Product name associated with the seats.';


--
-- Name: COLUMN organization_seat_summary.seats_purchased; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.seats_purchased IS 'Count of active entitlements at the organization/product level (treated as seats purchased).';


--
-- Name: COLUMN organization_seat_summary.seats_allocated; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.seats_allocated IS 'Distinct count of persons linked to active entitlements for the organization/product.';


--
-- Name: COLUMN organization_seat_summary.seats_available; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_summary.seats_available IS 'Seats purchased minus seats allocated, floored at zero.';


--
-- Name: organization_seat_utilization; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.organization_seat_utilization AS
 SELECT organization_id,
    organization_name,
    organization_category,
    product_id,
    product_sku,
    product_name,
    pool_id,
    total_seats,
    seats_allocated,
    seats_available,
        CASE
            WHEN (total_seats > 0) THEN round(((100.0 * (seats_allocated)::numeric) / (total_seats)::numeric), 2)
            ELSE NULL::numeric
        END AS utilization_pct
   FROM analytics.organization_membership_pools omp
  ORDER BY organization_name, product_name;


ALTER VIEW analytics.organization_seat_utilization OWNER TO apiary;

--
-- Name: VIEW organization_seat_utilization; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.organization_seat_utilization IS 'Seat utilization per organization membership pool; use for over/under-allocation dashboards.';


--
-- Name: COLUMN organization_seat_utilization.organization_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.organization_id IS 'Hub organization primary key (UUID). Join key for organization context.';


--
-- Name: COLUMN organization_seat_utilization.organization_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.organization_name IS 'Organization display name.';


--
-- Name: COLUMN organization_seat_utilization.product_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.product_id IS 'Product tied to this seat pool.';


--
-- Name: COLUMN organization_seat_utilization.pool_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.pool_id IS 'organization_membership_pools primary key (UUID).';


--
-- Name: COLUMN organization_seat_utilization.total_seats; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.total_seats IS 'Total seats in the pool.';


--
-- Name: COLUMN organization_seat_utilization.seats_allocated; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.seats_allocated IS 'Number of seats currently allocated to members.';


--
-- Name: COLUMN organization_seat_utilization.seats_available; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.seats_available IS 'Seats not yet allocated (total_seats - seats_allocated).';


--
-- Name: COLUMN organization_seat_utilization.utilization_pct; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.organization_seat_utilization.utilization_pct IS 'Percentage of seats allocated (0–100). Use for utilization dashboards and alerts.';


--
-- Name: subscription_churn_by_month; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.subscription_churn_by_month AS
 SELECT (date_trunc('month'::text, s.canceled_at))::date AS month,
    mp.id AS membership_plan_id,
    mp.code AS plan_code,
    mp.name AS plan_name,
    count(*) AS canceled_count
   FROM (public.subscriptions s
     JOIN public.membership_plans mp ON ((mp.id = s.membership_plan_id)))
  WHERE (s.canceled_at IS NOT NULL)
  GROUP BY (date_trunc('month'::text, s.canceled_at)), mp.id, mp.code, mp.name
  ORDER BY ((date_trunc('month'::text, s.canceled_at))::date) DESC, mp.name;


ALTER VIEW analytics.subscription_churn_by_month OWNER TO apiary;

--
-- Name: VIEW subscription_churn_by_month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.subscription_churn_by_month IS 'Count of subscriptions canceled per calendar month and plan, for churn analysis.';


--
-- Name: COLUMN subscription_churn_by_month.month; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.subscription_churn_by_month.month IS 'Calendar month (first day) when the subscription was canceled.';


--
-- Name: COLUMN subscription_churn_by_month.membership_plan_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.subscription_churn_by_month.membership_plan_id IS 'Hub membership_plans primary key (UUID).';


--
-- Name: COLUMN subscription_churn_by_month.plan_code; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.subscription_churn_by_month.plan_code IS 'Plan code for grouping.';


--
-- Name: COLUMN subscription_churn_by_month.plan_name; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.subscription_churn_by_month.plan_name IS 'Display name of the plan.';


--
-- Name: COLUMN subscription_churn_by_month.canceled_count; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.subscription_churn_by_month.canceled_count IS 'Number of subscriptions canceled in this month for this plan.';


--
-- Name: unified_member; Type: VIEW; Schema: analytics; Owner: apiary
--

CREATE VIEW analytics.unified_member AS
 SELECT p.id AS person_id,
    jsonb_build_object('person', to_jsonb(p.*), 'identity_map', jsonb_build_object('email', p.email, 'cognito_sub', p.cognito_sub, 'salesforce_contact_id', p.salesforce_contact_id, 'medusa_customer_id', p.medusa_customer_id, 'cvent_contact_id', p.cvent_contact_id, 'camp_contact_id', p.camp_contact_id, 'netsuite_entity_id', p.netsuite_entity_id), 'person_history', COALESCE(ph.rows, '[]'::jsonb), 'organizations', COALESCE(orgs.rows, '[]'::jsonb), 'person_organizations_history', COALESCE(poh.rows, '[]'::jsonb), 'memberships', COALESCE(mems.rows, '[]'::jsonb), 'person_memberships_history', COALESCE(pmh.rows, '[]'::jsonb), 'entitlements', COALESCE(ents.rows, '[]'::jsonb), 'person_entitlements_history', COALESCE(peh.rows, '[]'::jsonb)) AS person_document
   FROM (((((((public.persons p
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(ph_1.*))::jsonb ORDER BY ph_1.valid_from) AS rows
           FROM public.persons_history ph_1
          WHERE (ph_1.id = p.id)) ph ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg(jsonb_build_object('organization', to_jsonb(o.*), 'link', to_jsonb(po.*)) ORDER BY o.name) AS rows
           FROM (public.person_organizations po
             JOIN public.organizations o ON ((o.id = po.organization_id)))
          WHERE (po.person_id = p.id)) orgs ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(poh_1.*))::jsonb ORDER BY poh_1.valid_from) AS rows
           FROM public.person_organizations_history poh_1
          WHERE (poh_1.person_id = p.id)) poh ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg(jsonb_build_object('membership', to_jsonb(m.*), 'link', to_jsonb(pm.*)) ORDER BY m.expires_at, m.created_at) AS rows
           FROM (public.person_memberships pm
             JOIN public.memberships m ON ((m.id = pm.membership_id)))
          WHERE (pm.person_id = p.id)) mems ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(pmh_1.*))::jsonb ORDER BY pmh_1.valid_from) AS rows
           FROM public.person_memberships_history pmh_1
          WHERE (pmh_1.person_id = p.id)) pmh ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg(jsonb_build_object('entitlement', to_jsonb(e.*), 'product', to_jsonb(pr.*), 'link', to_jsonb(pe.*)) ORDER BY e.created_at) AS rows
           FROM ((public.person_entitlements pe
             JOIN public.entitlements e ON ((e.id = pe.entitlement_id)))
             LEFT JOIN public.products pr ON ((pr.id = e.product_id)))
          WHERE (pe.person_id = p.id)) ents ON (true))
     LEFT JOIN LATERAL ( SELECT jsonb_agg((row_to_json(peh_1.*))::jsonb ORDER BY peh_1.valid_from) AS rows
           FROM public.person_entitlements_history peh_1
          WHERE (peh_1.person_id = p.id)) peh ON (true))
  ORDER BY p.email;


ALTER VIEW analytics.unified_member OWNER TO apiary;

--
-- Name: VIEW unified_member; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON VIEW analytics.unified_member IS 'Unified member document for analytics and Metabase; denormalized person + identity + relationships + history.';


--
-- Name: COLUMN unified_member.person_id; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.unified_member.person_id IS 'Hub person primary key (UUID) for this unified member document.';


--
-- Name: COLUMN unified_member.person_document; Type: COMMENT; Schema: analytics; Owner: apiary
--

COMMENT ON COLUMN analytics.unified_member.person_document IS 'JSONB document with person, identity_map, organizations, memberships, entitlements, and history arrays.';


--
-- Name: events; Type: TABLE; Schema: audit; Owner: apiary
--

CREATE TABLE audit.events (
    id bigint NOT NULL,
    table_name text NOT NULL,
    row_id uuid NOT NULL,
    operation text NOT NULL,
    old_data jsonb,
    new_data jsonb,
    changed_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE audit.events OWNER TO apiary;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: audit; Owner: apiary
--

CREATE SEQUENCE audit.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE audit.events_id_seq OWNER TO apiary;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: apiary
--

ALTER SEQUENCE audit.events_id_seq OWNED BY audit.events.id;


--
-- Name: contributor_engagement; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.contributor_engagement (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    engagement_type text NOT NULL,
    source_system text NOT NULL,
    source_id text NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb,
    organization_id uuid,
    entitlement_id uuid,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.contributor_engagement OWNER TO apiary;

--
-- Name: contributor_profiles; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.contributor_profiles (
    person_id uuid NOT NULL,
    contributor_type text NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    attribution_consent boolean DEFAULT false NOT NULL,
    contact_for_opportunities boolean DEFAULT false NOT NULL,
    terms_version text,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text
);


ALTER TABLE public.contributor_profiles OWNER TO apiary;

--
-- Name: contributor_profiles_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.contributor_profiles_history (
    history_id bigint NOT NULL,
    person_id uuid NOT NULL,
    contributor_type text NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    attribution_consent boolean NOT NULL,
    contact_for_opportunities boolean NOT NULL,
    terms_version text,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.contributor_profiles_history OWNER TO apiary;

--
-- Name: contributor_profiles_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.contributor_profiles_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contributor_profiles_history_history_id_seq OWNER TO apiary;

--
-- Name: contributor_profiles_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.contributor_profiles_history_history_id_seq OWNED BY public.contributor_profiles_history.history_id;


--
-- Name: contributor_types; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.contributor_types (
    code text NOT NULL,
    label text NOT NULL,
    description text,
    sort_order integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.contributor_types OWNER TO apiary;

--
-- Name: engagement_types; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.engagement_types (
    code text NOT NULL,
    label text NOT NULL,
    description text,
    sort_order integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.engagement_types OWNER TO apiary;

--
-- Name: entitlements_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.entitlements_history (
    history_id bigint NOT NULL,
    id uuid NOT NULL,
    person_id uuid,
    product_id uuid,
    organization_id uuid,
    status text NOT NULL,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text,
    membership_pool_id uuid,
    origin_person_id uuid,
    origin_organization_id uuid
);


ALTER TABLE public.entitlements_history OWNER TO apiary;

--
-- Name: entitlements_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.entitlements_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entitlements_history_history_id_seq OWNER TO apiary;

--
-- Name: entitlements_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.entitlements_history_history_id_seq OWNED BY public.entitlements_history.history_id;


--
-- Name: memberships_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.memberships_history (
    history_id bigint NOT NULL,
    id uuid NOT NULL,
    person_id uuid,
    organization_id uuid,
    name text,
    status text NOT NULL,
    expires_at timestamp with time zone,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.memberships_history OWNER TO apiary;

--
-- Name: memberships_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.memberships_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.memberships_history_history_id_seq OWNER TO apiary;

--
-- Name: memberships_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.memberships_history_history_id_seq OWNED BY public.memberships_history.history_id;


--
-- Name: organization_invites; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.organization_invites (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    token text NOT NULL,
    organization_id uuid NOT NULL,
    invited_by_person_id uuid NOT NULL,
    email text,
    role text,
    expires_at timestamp with time zone NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text
);


ALTER TABLE public.organization_invites OWNER TO apiary;

--
-- Name: TABLE organization_invites; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON TABLE public.organization_invites IS 'Pending and historical organization invites; token is used in accept URL.';


--
-- Name: COLUMN organization_invites.token; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_invites.token IS 'Secure token for accept link; single-use, invalid after accept or expiry.';


--
-- Name: COLUMN organization_invites.organization_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_invites.organization_id IS 'Organization the invitee will join on accept.';


--
-- Name: COLUMN organization_invites.invited_by_person_id; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_invites.invited_by_person_id IS 'Person who created the invite (must be owner/admin of the organization).';


--
-- Name: COLUMN organization_invites.email; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_invites.email IS 'Optional invitee email for display or future email-based matching.';


--
-- Name: COLUMN organization_invites.role; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_invites.role IS 'Role to assign in person_organizations when invite is accepted.';


--
-- Name: COLUMN organization_invites.expires_at; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_invites.expires_at IS 'Invite is invalid after this time.';


--
-- Name: COLUMN organization_invites.status; Type: COMMENT; Schema: public; Owner: apiary
--

COMMENT ON COLUMN public.organization_invites.status IS 'pending | accepted | expired | revoked.';


--
-- Name: organization_membership_pools_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.organization_membership_pools_history (
    history_id bigint NOT NULL,
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    product_id uuid NOT NULL,
    total_seats integer NOT NULL,
    status text NOT NULL,
    effective_from timestamp with time zone,
    effective_to timestamp with time zone,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.organization_membership_pools_history OWNER TO apiary;

--
-- Name: organization_membership_pools_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.organization_membership_pools_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organization_membership_pools_history_history_id_seq OWNER TO apiary;

--
-- Name: organization_membership_pools_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.organization_membership_pools_history_history_id_seq OWNED BY public.organization_membership_pools_history.history_id;


--
-- Name: organizations_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.organizations_history (
    history_id bigint NOT NULL,
    id uuid NOT NULL,
    name text,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text,
    category text
);


ALTER TABLE public.organizations_history OWNER TO apiary;

--
-- Name: organizations_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.organizations_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organizations_history_history_id_seq OWNER TO apiary;

--
-- Name: organizations_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.organizations_history_history_id_seq OWNED BY public.organizations_history.history_id;


--
-- Name: person_entitlements_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.person_entitlements_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_entitlements_history_history_id_seq OWNER TO apiary;

--
-- Name: person_entitlements_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.person_entitlements_history_history_id_seq OWNED BY public.person_entitlements_history.history_id;


--
-- Name: person_memberships_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.person_memberships_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_memberships_history_history_id_seq OWNER TO apiary;

--
-- Name: person_memberships_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.person_memberships_history_history_id_seq OWNED BY public.person_memberships_history.history_id;


--
-- Name: person_organizations_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.person_organizations_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_organizations_history_history_id_seq OWNER TO apiary;

--
-- Name: person_organizations_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.person_organizations_history_history_id_seq OWNED BY public.person_organizations_history.history_id;


--
-- Name: persons_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.persons_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.persons_history_history_id_seq OWNER TO apiary;

--
-- Name: persons_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.persons_history_history_id_seq OWNED BY public.persons_history.history_id;


--
-- Name: products_history; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.products_history (
    history_id bigint NOT NULL,
    id uuid NOT NULL,
    sku text,
    name text,
    description text,
    version integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id text,
    created_via text,
    updated_by_id text,
    updated_via text,
    valid_from timestamp with time zone NOT NULL,
    valid_to timestamp with time zone NOT NULL,
    changed_by_id text,
    changed_via text
);


ALTER TABLE public.products_history OWNER TO apiary;

--
-- Name: products_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.products_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_history_history_id_seq OWNER TO apiary;

--
-- Name: products_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.products_history_history_id_seq OWNED BY public.products_history.history_id;


--
-- Name: stripe_events; Type: TABLE; Schema: public; Owner: apiary
--

CREATE TABLE public.stripe_events (
    id bigint NOT NULL,
    stripe_event_id text NOT NULL,
    type text NOT NULL,
    status text DEFAULT 'received'::text NOT NULL,
    error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone
);


ALTER TABLE public.stripe_events OWNER TO apiary;

--
-- Name: stripe_events_id_seq; Type: SEQUENCE; Schema: public; Owner: apiary
--

CREATE SEQUENCE public.stripe_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stripe_events_id_seq OWNER TO apiary;

--
-- Name: stripe_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apiary
--

ALTER SEQUENCE public.stripe_events_id_seq OWNED BY public.stripe_events.id;


--
-- Name: events id; Type: DEFAULT; Schema: audit; Owner: apiary
--

ALTER TABLE ONLY audit.events ALTER COLUMN id SET DEFAULT nextval('audit.events_id_seq'::regclass);


--
-- Name: contributor_profiles_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_profiles_history ALTER COLUMN history_id SET DEFAULT nextval('public.contributor_profiles_history_history_id_seq'::regclass);


--
-- Name: entitlements_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements_history ALTER COLUMN history_id SET DEFAULT nextval('public.entitlements_history_history_id_seq'::regclass);


--
-- Name: memberships_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.memberships_history ALTER COLUMN history_id SET DEFAULT nextval('public.memberships_history_history_id_seq'::regclass);


--
-- Name: organization_membership_pools_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_membership_pools_history ALTER COLUMN history_id SET DEFAULT nextval('public.organization_membership_pools_history_history_id_seq'::regclass);


--
-- Name: organizations_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organizations_history ALTER COLUMN history_id SET DEFAULT nextval('public.organizations_history_history_id_seq'::regclass);


--
-- Name: person_entitlements_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_entitlements_history ALTER COLUMN history_id SET DEFAULT nextval('public.person_entitlements_history_history_id_seq'::regclass);


--
-- Name: person_memberships_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_memberships_history ALTER COLUMN history_id SET DEFAULT nextval('public.person_memberships_history_history_id_seq'::regclass);


--
-- Name: person_organizations_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_organizations_history ALTER COLUMN history_id SET DEFAULT nextval('public.person_organizations_history_history_id_seq'::regclass);


--
-- Name: persons_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.persons_history ALTER COLUMN history_id SET DEFAULT nextval('public.persons_history_history_id_seq'::regclass);


--
-- Name: products_history history_id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.products_history ALTER COLUMN history_id SET DEFAULT nextval('public.products_history_history_id_seq'::regclass);


--
-- Name: stripe_events id; Type: DEFAULT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.stripe_events ALTER COLUMN id SET DEFAULT nextval('public.stripe_events_id_seq'::regclass);


--
-- Data for Name: events; Type: TABLE DATA; Schema: audit; Owner: apiary
--

COPY audit.events (id, table_name, row_id, operation, old_data, new_data, changed_at) FROM stdin;
\.


--
-- Data for Name: big_commerce_orders; Type: TABLE DATA; Schema: demo; Owner: apiary
--

COPY demo.big_commerce_orders (id, person_id, order_id, total_cents, channel, created_at) FROM stdin;
73f257c8-658b-43e9-b151-9eb731a9d431	d1000001-0000-4000-8000-000000000001	bc_d1000001000040008000000000000001_1	19999	web	2026-02-25 11:38:31.423097+00
507702a3-b15a-40f2-95c2-e74892e9c886	d1000001-0000-4000-8000-000000000002	bc_d1000001000040008000000000000002_1	19999	web	2026-02-25 11:38:31.423097+00
c1de3482-617e-4e11-96dc-9e3eed9f3210	d1000001-0000-4000-8000-000000000003	bc_d1000001000040008000000000000003_1	19999	web	2026-02-25 11:38:31.423097+00
6a809229-18bf-4fd2-ac03-7b9acced92c4	d1000001-0000-4000-8000-000000000004	bc_d1000001000040008000000000000004_1	19999	web	2026-02-25 11:38:31.423097+00
5a84d1a5-92f0-4040-825f-8ab6d13a6d6d	d1000001-0000-4000-8000-000000000005	bc_d1000001000040008000000000000005_1	19999	web	2026-02-25 11:38:31.423097+00
512f639b-0d84-4a9a-900c-b4a610d01f64	d1000001-0000-4000-8000-000000000006	bc_d1000001000040008000000000000006_1	19999	web	2026-02-25 11:38:31.423097+00
abdf77a3-ee7d-4229-aae2-7f154408d773	d1000001-0000-4000-8000-000000000007	bc_d1000001000040008000000000000007_1	19999	web	2026-02-25 11:38:31.423097+00
251074c7-4663-428a-9600-cf2ad368cf11	d1000001-0000-4000-8000-000000000008	bc_d1000001000040008000000000000008_1	19999	web	2026-02-25 11:38:31.423097+00
5c9dc3e6-4580-4539-b854-dc83d590541d	d1000001-0000-4000-8000-000000000009	bc_d1000001000040008000000000000009_1	19999	web	2026-02-25 11:38:31.423097+00
62d8bb39-b2fe-4ece-83bf-ef3a5e48437a	d1000001-0000-4000-8000-00000000000a	bc_d100000100004000800000000000000a_1	19999	web	2026-02-25 11:38:31.423097+00
bcd39f96-ec42-4c68-bf7f-dc20260aaeec	d1000001-0000-4000-8000-000000000001	bc_d1000001000040008000000000000001_2	4500	mobile	2026-02-25 11:38:31.425139+00
edffb4a5-9f5b-4653-ab14-3736f6021ebe	d1000001-0000-4000-8000-000000000002	bc_d1000001000040008000000000000002_2	4500	mobile	2026-02-25 11:38:31.425139+00
121f1149-9ed1-4f0f-b2d8-cc1970745ae7	d1000001-0000-4000-8000-000000000003	bc_d1000001000040008000000000000003_2	4500	mobile	2026-02-25 11:38:31.425139+00
a0ca17d9-e01e-4292-b005-8f2fb80f5eae	d1000001-0000-4000-8000-000000000004	bc_d1000001000040008000000000000004_2	4500	mobile	2026-02-25 11:38:31.425139+00
f4fc9d8a-ca0f-42d5-9f70-fbadfacfe2ed	d1000001-0000-4000-8000-000000000005	bc_d1000001000040008000000000000005_2	4500	mobile	2026-02-25 11:38:31.425139+00
3f600fdb-3817-4f61-a5f0-40de1fe8cf0f	d1000001-0000-4000-8000-000000000006	bc_d1000001000040008000000000000006_2	4500	mobile	2026-02-25 11:38:31.425139+00
0be819bf-4edb-4279-90a7-5e979e56afc7	d1000001-0000-4000-8000-000000000007	bc_d1000001000040008000000000000007_2	4500	mobile	2026-02-25 11:38:31.425139+00
9a79cda2-6070-4195-a204-befd8f76f249	d1000001-0000-4000-8000-000000000008	bc_d1000001000040008000000000000008_2	4500	mobile	2026-02-25 11:38:31.425139+00
54dd86cc-a271-4b43-8bce-13ee7193e13f	d1000001-0000-4000-8000-000000000009	bc_d1000001000040008000000000000009_2	4500	mobile	2026-02-25 11:38:31.425139+00
8e3b4f1d-6926-49cc-b7af-e3077bc530d0	d1000001-0000-4000-8000-00000000000a	bc_d100000100004000800000000000000a_2	4500	mobile	2026-02-25 11:38:31.425139+00
d3000005-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000000b	bc_bulk_11_1	5048	api	2026-02-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000005	d1000001-0000-4000-8000-00000000000c	bc_bulk_12_1	5065	pos	2026-02-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000009	d1000001-0000-4000-8000-00000000000d	bc_bulk_13_1	5082	web	2026-01-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000000d	d1000001-0000-4000-8000-00000000000e	bc_bulk_14_1	5099	mobile	2026-01-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000011	d1000001-0000-4000-8000-00000000000f	bc_bulk_15_1	5116	api	2026-01-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000015	d1000001-0000-4000-8000-000000000010	bc_bulk_16_1	5133	pos	2026-01-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000019	d1000001-0000-4000-8000-000000000011	bc_bulk_17_1	5150	web	2026-01-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000001d	d1000001-0000-4000-8000-000000000012	bc_bulk_18_1	5167	mobile	2026-01-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000021	d1000001-0000-4000-8000-000000000013	bc_bulk_19_1	5184	api	2025-12-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000025	d1000001-0000-4000-8000-000000000014	bc_bulk_20_1	5201	pos	2025-12-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000029	d1000001-0000-4000-8000-000000000015	bc_bulk_21_1	5218	web	2025-12-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000002d	d1000001-0000-4000-8000-000000000016	bc_bulk_22_1	5235	mobile	2025-12-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000031	d1000001-0000-4000-8000-000000000017	bc_bulk_23_1	5252	api	2025-12-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000035	d1000001-0000-4000-8000-000000000018	bc_bulk_24_1	5269	pos	2025-12-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000039	d1000001-0000-4000-8000-000000000019	bc_bulk_25_1	5286	web	2025-12-01 11:38:31.520924+00
d3000005-0000-4000-8000-00000000003d	d1000001-0000-4000-8000-00000000001a	bc_bulk_26_1	5303	mobile	2025-11-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000041	d1000001-0000-4000-8000-00000000001b	bc_bulk_27_1	5320	api	2025-11-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000045	d1000001-0000-4000-8000-00000000001c	bc_bulk_28_1	5337	pos	2025-11-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000049	d1000001-0000-4000-8000-00000000001d	bc_bulk_29_1	5354	web	2025-11-11 11:38:31.520924+00
d3000005-0000-4000-8000-00000000004d	d1000001-0000-4000-8000-00000000001e	bc_bulk_30_1	5371	mobile	2025-11-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000051	d1000001-0000-4000-8000-00000000001f	bc_bulk_31_1	5388	api	2025-11-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000055	d1000001-0000-4000-8000-000000000020	bc_bulk_32_1	5405	pos	2025-10-27 11:38:31.520924+00
d3000005-0000-4000-8000-000000000059	d1000001-0000-4000-8000-000000000021	bc_bulk_33_1	5422	web	2025-10-22 11:38:31.520924+00
d3000005-0000-4000-8000-00000000005d	d1000001-0000-4000-8000-000000000022	bc_bulk_34_1	5439	mobile	2025-10-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000061	d1000001-0000-4000-8000-000000000023	bc_bulk_35_1	5456	api	2025-10-12 11:38:31.520924+00
d3000005-0000-4000-8000-000000000065	d1000001-0000-4000-8000-000000000024	bc_bulk_36_1	5473	pos	2025-10-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000069	d1000001-0000-4000-8000-000000000025	bc_bulk_37_1	5490	web	2025-10-02 11:38:31.520924+00
d3000005-0000-4000-8000-00000000006d	d1000001-0000-4000-8000-000000000026	bc_bulk_38_1	5507	mobile	2025-09-27 11:38:31.520924+00
d3000005-0000-4000-8000-000000000071	d1000001-0000-4000-8000-000000000027	bc_bulk_39_1	5524	api	2025-09-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000075	d1000001-0000-4000-8000-000000000028	bc_bulk_40_1	5541	pos	2025-09-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000079	d1000001-0000-4000-8000-000000000029	bc_bulk_41_1	5558	web	2025-09-12 11:38:31.520924+00
d3000005-0000-4000-8000-00000000007d	d1000001-0000-4000-8000-00000000002a	bc_bulk_42_1	5575	mobile	2025-09-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000081	d1000001-0000-4000-8000-00000000002b	bc_bulk_43_1	5592	api	2025-09-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000085	d1000001-0000-4000-8000-00000000002c	bc_bulk_44_1	5609	pos	2025-08-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000089	d1000001-0000-4000-8000-00000000002d	bc_bulk_45_1	5626	web	2025-08-23 11:38:31.520924+00
d3000005-0000-4000-8000-00000000008d	d1000001-0000-4000-8000-00000000002e	bc_bulk_46_1	5643	mobile	2025-08-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000091	d1000001-0000-4000-8000-00000000002f	bc_bulk_47_1	5660	api	2025-08-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000095	d1000001-0000-4000-8000-000000000030	bc_bulk_48_1	5677	pos	2025-08-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000099	d1000001-0000-4000-8000-000000000031	bc_bulk_49_1	5694	web	2025-08-03 11:38:31.520924+00
d3000005-0000-4000-8000-00000000009d	d1000001-0000-4000-8000-000000000032	bc_bulk_50_1	5711	mobile	2025-07-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a1	d1000001-0000-4000-8000-000000000033	bc_bulk_51_1	5728	api	2025-07-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a5	d1000001-0000-4000-8000-000000000034	bc_bulk_52_1	5745	pos	2025-07-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a9	d1000001-0000-4000-8000-000000000035	bc_bulk_53_1	5762	web	2025-07-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ad	d1000001-0000-4000-8000-000000000036	bc_bulk_54_1	5779	mobile	2025-07-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b1	d1000001-0000-4000-8000-000000000037	bc_bulk_55_1	5796	api	2025-07-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b5	d1000001-0000-4000-8000-000000000038	bc_bulk_56_1	5813	pos	2025-06-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b9	d1000001-0000-4000-8000-000000000039	bc_bulk_57_1	5830	web	2025-06-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000bd	d1000001-0000-4000-8000-00000000003a	bc_bulk_58_1	5847	mobile	2025-06-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c1	d1000001-0000-4000-8000-00000000003b	bc_bulk_59_1	5864	api	2025-06-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c5	d1000001-0000-4000-8000-00000000003c	bc_bulk_60_1	5881	pos	2025-06-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c9	d1000001-0000-4000-8000-00000000003d	bc_bulk_61_1	5898	web	2025-06-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000cd	d1000001-0000-4000-8000-00000000003e	bc_bulk_62_1	5915	mobile	2025-05-30 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d1	d1000001-0000-4000-8000-00000000003f	bc_bulk_63_1	5932	api	2025-05-25 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d5	d1000001-0000-4000-8000-000000000040	bc_bulk_64_1	5949	pos	2025-05-20 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d9	d1000001-0000-4000-8000-000000000041	bc_bulk_65_1	5966	web	2025-05-15 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000dd	d1000001-0000-4000-8000-000000000042	bc_bulk_66_1	5983	mobile	2025-05-10 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e1	d1000001-0000-4000-8000-000000000043	bc_bulk_67_1	6000	api	2025-05-05 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e5	d1000001-0000-4000-8000-000000000044	bc_bulk_68_1	6017	pos	2025-04-30 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e9	d1000001-0000-4000-8000-000000000045	bc_bulk_69_1	6034	web	2025-04-25 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ed	d1000001-0000-4000-8000-000000000046	bc_bulk_70_1	6051	mobile	2025-04-20 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f1	d1000001-0000-4000-8000-000000000047	bc_bulk_71_1	6068	api	2025-04-15 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f5	d1000001-0000-4000-8000-000000000048	bc_bulk_72_1	6085	pos	2025-04-10 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f9	d1000001-0000-4000-8000-000000000049	bc_bulk_73_1	6102	web	2025-04-05 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000fd	d1000001-0000-4000-8000-00000000004a	bc_bulk_74_1	6119	mobile	2025-03-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000101	d1000001-0000-4000-8000-00000000004b	bc_bulk_75_1	6136	api	2025-03-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000105	d1000001-0000-4000-8000-00000000004c	bc_bulk_76_1	6153	pos	2025-03-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000109	d1000001-0000-4000-8000-00000000004d	bc_bulk_77_1	6170	web	2025-03-16 11:38:31.520924+00
d3000005-0000-4000-8000-00000000010d	d1000001-0000-4000-8000-00000000004e	bc_bulk_78_1	6187	mobile	2025-03-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000111	d1000001-0000-4000-8000-00000000004f	bc_bulk_79_1	6204	api	2025-03-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000115	d1000001-0000-4000-8000-000000000050	bc_bulk_80_1	6221	pos	2025-03-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000119	d1000001-0000-4000-8000-000000000051	bc_bulk_81_1	6238	web	2026-02-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000011d	d1000001-0000-4000-8000-000000000052	bc_bulk_82_1	6255	mobile	2026-02-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000121	d1000001-0000-4000-8000-000000000053	bc_bulk_83_1	6272	api	2026-02-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000125	d1000001-0000-4000-8000-000000000054	bc_bulk_84_1	6289	pos	2026-02-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000129	d1000001-0000-4000-8000-000000000055	bc_bulk_85_1	6306	web	2026-02-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000012d	d1000001-0000-4000-8000-000000000056	bc_bulk_86_1	6323	mobile	2026-01-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000131	d1000001-0000-4000-8000-000000000057	bc_bulk_87_1	6340	api	2026-01-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000135	d1000001-0000-4000-8000-000000000058	bc_bulk_88_1	6357	pos	2026-01-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000139	d1000001-0000-4000-8000-000000000059	bc_bulk_89_1	6374	web	2026-01-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000013d	d1000001-0000-4000-8000-00000000005a	bc_bulk_90_1	6391	mobile	2026-01-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000141	d1000001-0000-4000-8000-00000000005b	bc_bulk_91_1	6408	api	2026-01-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000145	d1000001-0000-4000-8000-00000000005c	bc_bulk_92_1	6425	pos	2025-12-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000149	d1000001-0000-4000-8000-00000000005d	bc_bulk_93_1	6442	web	2025-12-26 11:38:31.520924+00
d3000005-0000-4000-8000-00000000014d	d1000001-0000-4000-8000-00000000005e	bc_bulk_94_1	6459	mobile	2025-12-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000151	d1000001-0000-4000-8000-00000000005f	bc_bulk_95_1	6476	api	2025-12-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000155	d1000001-0000-4000-8000-000000000060	bc_bulk_96_1	6493	pos	2025-12-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000159	d1000001-0000-4000-8000-000000000061	bc_bulk_97_1	6510	web	2025-12-06 11:38:31.520924+00
d3000005-0000-4000-8000-00000000015d	d1000001-0000-4000-8000-000000000062	bc_bulk_98_1	6527	mobile	2025-12-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000161	d1000001-0000-4000-8000-000000000063	bc_bulk_99_1	6544	api	2025-11-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000165	d1000001-0000-4000-8000-000000000064	bc_bulk_100_1	6561	pos	2025-11-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000169	d1000001-0000-4000-8000-000000000065	bc_bulk_101_1	6578	web	2025-11-16 11:38:31.520924+00
d3000005-0000-4000-8000-00000000016d	d1000001-0000-4000-8000-000000000066	bc_bulk_102_1	6595	mobile	2025-11-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000171	d1000001-0000-4000-8000-000000000067	bc_bulk_103_1	6612	api	2025-11-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000175	d1000001-0000-4000-8000-000000000068	bc_bulk_104_1	6629	pos	2025-11-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000179	d1000001-0000-4000-8000-000000000069	bc_bulk_105_1	6646	web	2025-10-27 11:38:31.520924+00
d3000005-0000-4000-8000-00000000017d	d1000001-0000-4000-8000-00000000006a	bc_bulk_106_1	6663	mobile	2025-10-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000181	d1000001-0000-4000-8000-00000000006b	bc_bulk_107_1	6680	api	2025-10-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000185	d1000001-0000-4000-8000-00000000006c	bc_bulk_108_1	6697	pos	2025-10-12 11:38:31.520924+00
d3000005-0000-4000-8000-000000000189	d1000001-0000-4000-8000-00000000006d	bc_bulk_109_1	6714	web	2025-10-07 11:38:31.520924+00
d3000005-0000-4000-8000-00000000018d	d1000001-0000-4000-8000-00000000006e	bc_bulk_110_1	6731	mobile	2025-10-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000191	d1000001-0000-4000-8000-00000000006f	bc_bulk_111_1	6748	api	2025-09-27 11:38:31.520924+00
d3000005-0000-4000-8000-000000000195	d1000001-0000-4000-8000-000000000070	bc_bulk_112_1	6765	pos	2025-09-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000199	d1000001-0000-4000-8000-000000000071	bc_bulk_113_1	6782	web	2025-09-17 11:38:31.520924+00
d3000005-0000-4000-8000-00000000019d	d1000001-0000-4000-8000-000000000072	bc_bulk_114_1	6799	mobile	2025-09-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a1	d1000001-0000-4000-8000-000000000073	bc_bulk_115_1	6816	api	2025-09-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a5	d1000001-0000-4000-8000-000000000074	bc_bulk_116_1	6833	pos	2025-09-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a9	d1000001-0000-4000-8000-000000000075	bc_bulk_117_1	6850	web	2025-08-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ad	d1000001-0000-4000-8000-000000000076	bc_bulk_118_1	6867	mobile	2025-08-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b1	d1000001-0000-4000-8000-000000000077	bc_bulk_119_1	6884	api	2025-08-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b5	d1000001-0000-4000-8000-000000000078	bc_bulk_120_1	6901	pos	2025-08-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b9	d1000001-0000-4000-8000-000000000079	bc_bulk_121_1	6918	web	2025-08-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001bd	d1000001-0000-4000-8000-00000000007a	bc_bulk_122_1	6935	mobile	2025-08-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c1	d1000001-0000-4000-8000-00000000007b	bc_bulk_123_1	6952	api	2025-07-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c5	d1000001-0000-4000-8000-00000000007c	bc_bulk_124_1	6969	pos	2025-07-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c9	d1000001-0000-4000-8000-00000000007d	bc_bulk_125_1	6986	web	2025-07-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001cd	d1000001-0000-4000-8000-00000000007e	bc_bulk_126_1	7003	mobile	2025-07-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d1	d1000001-0000-4000-8000-00000000007f	bc_bulk_127_1	7020	api	2025-07-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d5	d1000001-0000-4000-8000-000000000080	bc_bulk_128_1	7037	pos	2025-07-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d9	d1000001-0000-4000-8000-000000000081	bc_bulk_129_1	7054	web	2025-06-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001dd	d1000001-0000-4000-8000-000000000082	bc_bulk_130_1	7071	mobile	2025-06-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e1	d1000001-0000-4000-8000-000000000083	bc_bulk_131_1	7088	api	2025-06-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e5	d1000001-0000-4000-8000-000000000084	bc_bulk_132_1	7105	pos	2025-06-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e9	d1000001-0000-4000-8000-000000000085	bc_bulk_133_1	7122	web	2025-06-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ed	d1000001-0000-4000-8000-000000000086	bc_bulk_134_1	7139	mobile	2025-06-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f1	d1000001-0000-4000-8000-000000000087	bc_bulk_135_1	7156	api	2025-05-30 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f5	d1000001-0000-4000-8000-000000000088	bc_bulk_136_1	7173	pos	2025-05-25 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f9	d1000001-0000-4000-8000-000000000089	bc_bulk_137_1	7190	web	2025-05-20 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001fd	d1000001-0000-4000-8000-00000000008a	bc_bulk_138_1	7207	mobile	2025-05-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000201	d1000001-0000-4000-8000-00000000008b	bc_bulk_139_1	7224	api	2025-05-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000205	d1000001-0000-4000-8000-00000000008c	bc_bulk_140_1	7241	pos	2025-05-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000209	d1000001-0000-4000-8000-00000000008d	bc_bulk_141_1	7258	web	2025-04-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000020d	d1000001-0000-4000-8000-00000000008e	bc_bulk_142_1	7275	mobile	2025-04-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000211	d1000001-0000-4000-8000-00000000008f	bc_bulk_143_1	7292	api	2025-04-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000215	d1000001-0000-4000-8000-000000000090	bc_bulk_144_1	7309	pos	2025-04-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000219	d1000001-0000-4000-8000-000000000091	bc_bulk_145_1	7326	web	2025-04-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000021d	d1000001-0000-4000-8000-000000000092	bc_bulk_146_1	7343	mobile	2025-04-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000221	d1000001-0000-4000-8000-000000000093	bc_bulk_147_1	7360	api	2025-03-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000225	d1000001-0000-4000-8000-000000000094	bc_bulk_148_1	7377	pos	2025-03-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000229	d1000001-0000-4000-8000-000000000095	bc_bulk_149_1	7394	web	2025-03-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000022d	d1000001-0000-4000-8000-000000000096	bc_bulk_150_1	7411	mobile	2025-03-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000231	d1000001-0000-4000-8000-000000000097	bc_bulk_151_1	7428	api	2025-03-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000235	d1000001-0000-4000-8000-000000000098	bc_bulk_152_1	7445	pos	2025-03-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000239	d1000001-0000-4000-8000-000000000099	bc_bulk_153_1	7462	web	2025-03-01 11:38:31.520924+00
d3000005-0000-4000-8000-00000000023d	d1000001-0000-4000-8000-00000000009a	bc_bulk_154_1	7479	mobile	2026-02-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000241	d1000001-0000-4000-8000-00000000009b	bc_bulk_155_1	7496	api	2026-02-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000245	d1000001-0000-4000-8000-00000000009c	bc_bulk_156_1	7513	pos	2026-02-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000249	d1000001-0000-4000-8000-00000000009d	bc_bulk_157_1	7530	web	2026-02-09 11:38:31.520924+00
d3000005-0000-4000-8000-00000000024d	d1000001-0000-4000-8000-00000000009e	bc_bulk_158_1	7547	mobile	2026-02-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000251	d1000001-0000-4000-8000-00000000009f	bc_bulk_159_1	7564	api	2026-01-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000255	d1000001-0000-4000-8000-0000000000a0	bc_bulk_160_1	7581	pos	2026-01-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000259	d1000001-0000-4000-8000-0000000000a1	bc_bulk_161_1	7598	web	2026-01-20 11:38:31.520924+00
d3000005-0000-4000-8000-00000000025d	d1000001-0000-4000-8000-0000000000a2	bc_bulk_162_1	7615	mobile	2026-01-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000261	d1000001-0000-4000-8000-0000000000a3	bc_bulk_163_1	7632	api	2026-01-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000265	d1000001-0000-4000-8000-0000000000a4	bc_bulk_164_1	7649	pos	2026-01-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000269	d1000001-0000-4000-8000-0000000000a5	bc_bulk_165_1	7666	web	2025-12-31 11:38:31.520924+00
d3000005-0000-4000-8000-00000000026d	d1000001-0000-4000-8000-0000000000a6	bc_bulk_166_1	7683	mobile	2025-12-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000271	d1000001-0000-4000-8000-0000000000a7	bc_bulk_167_1	7700	api	2025-12-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000275	d1000001-0000-4000-8000-0000000000a8	bc_bulk_168_1	7717	pos	2025-12-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000279	d1000001-0000-4000-8000-0000000000a9	bc_bulk_169_1	7734	web	2025-12-11 11:38:31.520924+00
d3000005-0000-4000-8000-00000000027d	d1000001-0000-4000-8000-0000000000aa	bc_bulk_170_1	7751	mobile	2025-12-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000281	d1000001-0000-4000-8000-0000000000ab	bc_bulk_171_1	7768	api	2025-12-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000285	d1000001-0000-4000-8000-0000000000ac	bc_bulk_172_1	7785	pos	2025-11-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000289	d1000001-0000-4000-8000-0000000000ad	bc_bulk_173_1	7802	web	2025-11-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000028d	d1000001-0000-4000-8000-0000000000ae	bc_bulk_174_1	7819	mobile	2025-11-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000291	d1000001-0000-4000-8000-0000000000af	bc_bulk_175_1	7836	api	2025-11-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000295	d1000001-0000-4000-8000-0000000000b0	bc_bulk_176_1	7853	pos	2025-11-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000299	d1000001-0000-4000-8000-0000000000b1	bc_bulk_177_1	7870	web	2025-11-01 11:38:31.520924+00
d3000005-0000-4000-8000-00000000029d	d1000001-0000-4000-8000-0000000000b2	bc_bulk_178_1	7887	mobile	2025-10-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a1	d1000001-0000-4000-8000-0000000000b3	bc_bulk_179_1	7904	api	2025-10-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a5	d1000001-0000-4000-8000-0000000000b4	bc_bulk_180_1	7921	pos	2025-10-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a9	d1000001-0000-4000-8000-0000000000b5	bc_bulk_181_1	7938	web	2025-10-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ad	d1000001-0000-4000-8000-0000000000b6	bc_bulk_182_1	7955	mobile	2025-10-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b1	d1000001-0000-4000-8000-0000000000b7	bc_bulk_183_1	7972	api	2025-10-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b5	d1000001-0000-4000-8000-0000000000b8	bc_bulk_184_1	7989	pos	2025-09-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b9	d1000001-0000-4000-8000-0000000000b9	bc_bulk_185_1	8006	web	2025-09-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002bd	d1000001-0000-4000-8000-0000000000ba	bc_bulk_186_1	8023	mobile	2025-09-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c1	d1000001-0000-4000-8000-0000000000bb	bc_bulk_187_1	8040	api	2025-09-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c5	d1000001-0000-4000-8000-0000000000bc	bc_bulk_188_1	8057	pos	2025-09-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c9	d1000001-0000-4000-8000-0000000000bd	bc_bulk_189_1	8074	web	2025-09-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002cd	d1000001-0000-4000-8000-0000000000be	bc_bulk_190_1	8091	mobile	2025-08-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d1	d1000001-0000-4000-8000-0000000000bf	bc_bulk_191_1	8108	api	2025-08-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d5	d1000001-0000-4000-8000-0000000000c0	bc_bulk_192_1	8125	pos	2025-08-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d9	d1000001-0000-4000-8000-0000000000c1	bc_bulk_193_1	8142	web	2025-08-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002dd	d1000001-0000-4000-8000-0000000000c2	bc_bulk_194_1	8159	mobile	2025-08-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e1	d1000001-0000-4000-8000-0000000000c3	bc_bulk_195_1	8176	api	2025-08-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e5	d1000001-0000-4000-8000-0000000000c4	bc_bulk_196_1	8193	pos	2025-07-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e9	d1000001-0000-4000-8000-0000000000c5	bc_bulk_197_1	8210	web	2025-07-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ed	d1000001-0000-4000-8000-0000000000c6	bc_bulk_198_1	8227	mobile	2025-07-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f1	d1000001-0000-4000-8000-0000000000c7	bc_bulk_199_1	8244	api	2025-07-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f5	d1000001-0000-4000-8000-0000000000c8	bc_bulk_200_1	8261	pos	2025-07-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f9	d1000001-0000-4000-8000-0000000000c9	bc_bulk_201_1	8278	web	2025-07-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002fd	d1000001-0000-4000-8000-0000000000ca	bc_bulk_202_1	8295	mobile	2025-06-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000301	d1000001-0000-4000-8000-0000000000cb	bc_bulk_203_1	8312	api	2025-06-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000305	d1000001-0000-4000-8000-0000000000cc	bc_bulk_204_1	8329	pos	2025-06-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000309	d1000001-0000-4000-8000-0000000000cd	bc_bulk_205_1	8346	web	2025-06-14 11:38:31.520924+00
d3000005-0000-4000-8000-00000000030d	d1000001-0000-4000-8000-0000000000ce	bc_bulk_206_1	8363	mobile	2025-06-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000311	d1000001-0000-4000-8000-0000000000cf	bc_bulk_207_1	8380	api	2025-06-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000315	d1000001-0000-4000-8000-0000000000d0	bc_bulk_208_1	8397	pos	2025-05-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000319	d1000001-0000-4000-8000-0000000000d1	bc_bulk_209_1	8414	web	2025-05-25 11:38:31.520924+00
d3000005-0000-4000-8000-00000000031d	d1000001-0000-4000-8000-0000000000d2	bc_bulk_210_1	8431	mobile	2025-05-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000000b	bc_bulk_11_2	5079	pos	2026-01-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000006	d1000001-0000-4000-8000-00000000000c	bc_bulk_12_2	5096	web	2026-01-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000000a	d1000001-0000-4000-8000-00000000000d	bc_bulk_13_2	5113	mobile	2026-01-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000000e	d1000001-0000-4000-8000-00000000000e	bc_bulk_14_2	5130	api	2026-01-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000012	d1000001-0000-4000-8000-00000000000f	bc_bulk_15_2	5147	pos	2026-01-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000016	d1000001-0000-4000-8000-000000000010	bc_bulk_16_2	5164	web	2026-01-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000001a	d1000001-0000-4000-8000-000000000011	bc_bulk_17_2	5181	mobile	2025-12-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000001e	d1000001-0000-4000-8000-000000000012	bc_bulk_18_2	5198	api	2025-12-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000022	d1000001-0000-4000-8000-000000000013	bc_bulk_19_2	5215	pos	2025-12-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000026	d1000001-0000-4000-8000-000000000014	bc_bulk_20_2	5232	web	2025-12-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000002a	d1000001-0000-4000-8000-000000000015	bc_bulk_21_2	5249	mobile	2025-12-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000002e	d1000001-0000-4000-8000-000000000016	bc_bulk_22_2	5266	api	2025-12-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000032	d1000001-0000-4000-8000-000000000017	bc_bulk_23_2	5283	pos	2025-11-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000036	d1000001-0000-4000-8000-000000000018	bc_bulk_24_2	5300	web	2025-11-25 11:38:31.520924+00
d3000005-0000-4000-8000-00000000003a	d1000001-0000-4000-8000-000000000019	bc_bulk_25_2	5317	mobile	2025-11-20 11:38:31.520924+00
d3000005-0000-4000-8000-00000000003e	d1000001-0000-4000-8000-00000000001a	bc_bulk_26_2	5334	api	2025-11-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000042	d1000001-0000-4000-8000-00000000001b	bc_bulk_27_2	5351	pos	2025-11-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000046	d1000001-0000-4000-8000-00000000001c	bc_bulk_28_2	5368	web	2025-11-05 11:38:31.520924+00
d3000005-0000-4000-8000-00000000004a	d1000001-0000-4000-8000-00000000001d	bc_bulk_29_2	5385	mobile	2025-10-31 11:38:31.520924+00
d3000005-0000-4000-8000-00000000004e	d1000001-0000-4000-8000-00000000001e	bc_bulk_30_2	5402	api	2025-10-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000052	d1000001-0000-4000-8000-00000000001f	bc_bulk_31_2	5419	pos	2025-10-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000056	d1000001-0000-4000-8000-000000000020	bc_bulk_32_2	5436	web	2025-10-16 11:38:31.520924+00
d3000005-0000-4000-8000-00000000005a	d1000001-0000-4000-8000-000000000021	bc_bulk_33_2	5453	mobile	2025-10-11 11:38:31.520924+00
d3000005-0000-4000-8000-00000000005e	d1000001-0000-4000-8000-000000000022	bc_bulk_34_2	5470	api	2025-10-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000062	d1000001-0000-4000-8000-000000000023	bc_bulk_35_2	5487	pos	2025-10-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000066	d1000001-0000-4000-8000-000000000024	bc_bulk_36_2	5504	web	2025-09-26 11:38:31.520924+00
d3000005-0000-4000-8000-00000000006a	d1000001-0000-4000-8000-000000000025	bc_bulk_37_2	5521	mobile	2025-09-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000006e	d1000001-0000-4000-8000-000000000026	bc_bulk_38_2	5538	api	2025-09-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000072	d1000001-0000-4000-8000-000000000027	bc_bulk_39_2	5555	pos	2025-09-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000076	d1000001-0000-4000-8000-000000000028	bc_bulk_40_2	5572	web	2025-09-06 11:38:31.520924+00
d3000005-0000-4000-8000-00000000007a	d1000001-0000-4000-8000-000000000029	bc_bulk_41_2	5589	mobile	2025-09-01 11:38:31.520924+00
d3000005-0000-4000-8000-00000000007e	d1000001-0000-4000-8000-00000000002a	bc_bulk_42_2	5606	api	2025-08-27 11:38:31.520924+00
d3000005-0000-4000-8000-000000000082	d1000001-0000-4000-8000-00000000002b	bc_bulk_43_2	5623	pos	2025-08-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000086	d1000001-0000-4000-8000-00000000002c	bc_bulk_44_2	5640	web	2025-08-17 11:38:31.520924+00
d3000005-0000-4000-8000-00000000008a	d1000001-0000-4000-8000-00000000002d	bc_bulk_45_2	5657	mobile	2025-08-12 11:38:31.520924+00
d3000005-0000-4000-8000-00000000008e	d1000001-0000-4000-8000-00000000002e	bc_bulk_46_2	5674	api	2025-08-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000092	d1000001-0000-4000-8000-00000000002f	bc_bulk_47_2	5691	pos	2025-08-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000096	d1000001-0000-4000-8000-000000000030	bc_bulk_48_2	5708	web	2025-07-28 11:38:31.520924+00
d3000005-0000-4000-8000-00000000009a	d1000001-0000-4000-8000-000000000031	bc_bulk_49_2	5725	mobile	2025-07-23 11:38:31.520924+00
d3000005-0000-4000-8000-00000000009e	d1000001-0000-4000-8000-000000000032	bc_bulk_50_2	5742	api	2025-07-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a2	d1000001-0000-4000-8000-000000000033	bc_bulk_51_2	5759	pos	2025-07-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a6	d1000001-0000-4000-8000-000000000034	bc_bulk_52_2	5776	web	2025-07-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000aa	d1000001-0000-4000-8000-000000000035	bc_bulk_53_2	5793	mobile	2025-07-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ae	d1000001-0000-4000-8000-000000000036	bc_bulk_54_2	5810	api	2025-06-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b2	d1000001-0000-4000-8000-000000000037	bc_bulk_55_2	5827	pos	2025-06-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b6	d1000001-0000-4000-8000-000000000038	bc_bulk_56_2	5844	web	2025-06-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ba	d1000001-0000-4000-8000-000000000039	bc_bulk_57_2	5861	mobile	2025-06-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000be	d1000001-0000-4000-8000-00000000003a	bc_bulk_58_2	5878	api	2025-06-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c2	d1000001-0000-4000-8000-00000000003b	bc_bulk_59_2	5895	pos	2025-06-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c6	d1000001-0000-4000-8000-00000000003c	bc_bulk_60_2	5912	web	2025-05-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ca	d1000001-0000-4000-8000-00000000003d	bc_bulk_61_2	5929	mobile	2025-05-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ce	d1000001-0000-4000-8000-00000000003e	bc_bulk_62_2	5946	api	2025-05-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d2	d1000001-0000-4000-8000-00000000003f	bc_bulk_63_2	5963	pos	2025-05-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d6	d1000001-0000-4000-8000-000000000040	bc_bulk_64_2	5980	web	2025-05-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000da	d1000001-0000-4000-8000-000000000041	bc_bulk_65_2	5997	mobile	2025-05-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000de	d1000001-0000-4000-8000-000000000042	bc_bulk_66_2	6014	api	2025-04-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e2	d1000001-0000-4000-8000-000000000043	bc_bulk_67_2	6031	pos	2025-04-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e6	d1000001-0000-4000-8000-000000000044	bc_bulk_68_2	6048	web	2025-04-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ea	d1000001-0000-4000-8000-000000000045	bc_bulk_69_2	6065	mobile	2025-04-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ee	d1000001-0000-4000-8000-000000000046	bc_bulk_70_2	6082	api	2025-04-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f2	d1000001-0000-4000-8000-000000000047	bc_bulk_71_2	6099	pos	2025-04-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f6	d1000001-0000-4000-8000-000000000048	bc_bulk_72_2	6116	web	2025-03-30 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000fa	d1000001-0000-4000-8000-000000000049	bc_bulk_73_2	6133	mobile	2025-03-25 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000fe	d1000001-0000-4000-8000-00000000004a	bc_bulk_74_2	6150	api	2025-03-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000102	d1000001-0000-4000-8000-00000000004b	bc_bulk_75_2	6167	pos	2025-03-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000106	d1000001-0000-4000-8000-00000000004c	bc_bulk_76_2	6184	web	2025-03-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000010a	d1000001-0000-4000-8000-00000000004d	bc_bulk_77_2	6201	mobile	2025-03-05 11:38:31.520924+00
d3000005-0000-4000-8000-00000000010e	d1000001-0000-4000-8000-00000000004e	bc_bulk_78_2	6218	api	2025-02-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000112	d1000001-0000-4000-8000-00000000004f	bc_bulk_79_2	6235	pos	2026-02-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000116	d1000001-0000-4000-8000-000000000050	bc_bulk_80_2	6252	web	2026-02-18 11:38:31.520924+00
d3000005-0000-4000-8000-00000000011a	d1000001-0000-4000-8000-000000000051	bc_bulk_81_2	6269	mobile	2026-02-13 11:38:31.520924+00
d3000005-0000-4000-8000-00000000011e	d1000001-0000-4000-8000-000000000052	bc_bulk_82_2	6286	api	2026-02-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000122	d1000001-0000-4000-8000-000000000053	bc_bulk_83_2	6303	pos	2026-02-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000126	d1000001-0000-4000-8000-000000000054	bc_bulk_84_2	6320	web	2026-01-29 11:38:31.520924+00
d3000005-0000-4000-8000-00000000012a	d1000001-0000-4000-8000-000000000055	bc_bulk_85_2	6337	mobile	2026-01-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000012e	d1000001-0000-4000-8000-000000000056	bc_bulk_86_2	6354	api	2026-01-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000132	d1000001-0000-4000-8000-000000000057	bc_bulk_87_2	6371	pos	2026-01-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000136	d1000001-0000-4000-8000-000000000058	bc_bulk_88_2	6388	web	2026-01-09 11:38:31.520924+00
d3000005-0000-4000-8000-00000000013a	d1000001-0000-4000-8000-000000000059	bc_bulk_89_2	6405	mobile	2026-01-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000013e	d1000001-0000-4000-8000-00000000005a	bc_bulk_90_2	6422	api	2025-12-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000142	d1000001-0000-4000-8000-00000000005b	bc_bulk_91_2	6439	pos	2025-12-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000146	d1000001-0000-4000-8000-00000000005c	bc_bulk_92_2	6456	web	2025-12-20 11:38:31.520924+00
d3000005-0000-4000-8000-00000000014a	d1000001-0000-4000-8000-00000000005d	bc_bulk_93_2	6473	mobile	2025-12-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000014e	d1000001-0000-4000-8000-00000000005e	bc_bulk_94_2	6490	api	2025-12-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000152	d1000001-0000-4000-8000-00000000005f	bc_bulk_95_2	6507	pos	2025-12-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000156	d1000001-0000-4000-8000-000000000060	bc_bulk_96_2	6524	web	2025-11-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000015a	d1000001-0000-4000-8000-000000000061	bc_bulk_97_2	6541	mobile	2025-11-25 11:38:31.520924+00
d3000005-0000-4000-8000-00000000015e	d1000001-0000-4000-8000-000000000062	bc_bulk_98_2	6558	api	2025-11-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000162	d1000001-0000-4000-8000-000000000063	bc_bulk_99_2	6575	pos	2025-11-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000166	d1000001-0000-4000-8000-000000000064	bc_bulk_100_2	6592	web	2025-11-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000016a	d1000001-0000-4000-8000-000000000065	bc_bulk_101_2	6609	mobile	2025-11-05 11:38:31.520924+00
d3000005-0000-4000-8000-00000000016e	d1000001-0000-4000-8000-000000000066	bc_bulk_102_2	6626	api	2025-10-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000172	d1000001-0000-4000-8000-000000000067	bc_bulk_103_2	6643	pos	2025-10-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000176	d1000001-0000-4000-8000-000000000068	bc_bulk_104_2	6660	web	2025-10-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000017a	d1000001-0000-4000-8000-000000000069	bc_bulk_105_2	6677	mobile	2025-10-16 11:38:31.520924+00
d3000005-0000-4000-8000-00000000017e	d1000001-0000-4000-8000-00000000006a	bc_bulk_106_2	6694	api	2025-10-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000182	d1000001-0000-4000-8000-00000000006b	bc_bulk_107_2	6711	pos	2025-10-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000186	d1000001-0000-4000-8000-00000000006c	bc_bulk_108_2	6728	web	2025-10-01 11:38:31.520924+00
d3000005-0000-4000-8000-00000000018a	d1000001-0000-4000-8000-00000000006d	bc_bulk_109_2	6745	mobile	2025-09-26 11:38:31.520924+00
d3000005-0000-4000-8000-00000000018e	d1000001-0000-4000-8000-00000000006e	bc_bulk_110_2	6762	api	2025-09-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000192	d1000001-0000-4000-8000-00000000006f	bc_bulk_111_2	6779	pos	2025-09-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000196	d1000001-0000-4000-8000-000000000070	bc_bulk_112_2	6796	web	2025-09-11 11:38:31.520924+00
d3000005-0000-4000-8000-00000000019a	d1000001-0000-4000-8000-000000000071	bc_bulk_113_2	6813	mobile	2025-09-06 11:38:31.520924+00
d3000005-0000-4000-8000-00000000019e	d1000001-0000-4000-8000-000000000072	bc_bulk_114_2	6830	api	2025-09-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a2	d1000001-0000-4000-8000-000000000073	bc_bulk_115_2	6847	pos	2025-08-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a6	d1000001-0000-4000-8000-000000000074	bc_bulk_116_2	6864	web	2025-08-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001aa	d1000001-0000-4000-8000-000000000075	bc_bulk_117_2	6881	mobile	2025-08-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ae	d1000001-0000-4000-8000-000000000076	bc_bulk_118_2	6898	api	2025-08-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b2	d1000001-0000-4000-8000-000000000077	bc_bulk_119_2	6915	pos	2025-08-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b6	d1000001-0000-4000-8000-000000000078	bc_bulk_120_2	6932	web	2025-08-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ba	d1000001-0000-4000-8000-000000000079	bc_bulk_121_2	6949	mobile	2025-07-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001be	d1000001-0000-4000-8000-00000000007a	bc_bulk_122_2	6966	api	2025-07-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c2	d1000001-0000-4000-8000-00000000007b	bc_bulk_123_2	6983	pos	2025-07-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c6	d1000001-0000-4000-8000-00000000007c	bc_bulk_124_2	7000	web	2025-07-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ca	d1000001-0000-4000-8000-00000000007d	bc_bulk_125_2	7017	mobile	2025-07-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ce	d1000001-0000-4000-8000-00000000007e	bc_bulk_126_2	7034	api	2025-07-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d2	d1000001-0000-4000-8000-00000000007f	bc_bulk_127_2	7051	pos	2025-06-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d6	d1000001-0000-4000-8000-000000000080	bc_bulk_128_2	7068	web	2025-06-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001da	d1000001-0000-4000-8000-000000000081	bc_bulk_129_2	7085	mobile	2025-06-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001de	d1000001-0000-4000-8000-000000000082	bc_bulk_130_2	7102	api	2025-06-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e2	d1000001-0000-4000-8000-000000000083	bc_bulk_131_2	7119	pos	2025-06-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e6	d1000001-0000-4000-8000-000000000084	bc_bulk_132_2	7136	web	2025-06-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ea	d1000001-0000-4000-8000-000000000085	bc_bulk_133_2	7153	mobile	2025-05-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ee	d1000001-0000-4000-8000-000000000086	bc_bulk_134_2	7170	api	2025-05-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f2	d1000001-0000-4000-8000-000000000087	bc_bulk_135_2	7187	pos	2025-05-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f6	d1000001-0000-4000-8000-000000000088	bc_bulk_136_2	7204	web	2025-05-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001fa	d1000001-0000-4000-8000-000000000089	bc_bulk_137_2	7221	mobile	2025-05-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001fe	d1000001-0000-4000-8000-00000000008a	bc_bulk_138_2	7238	api	2025-05-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000202	d1000001-0000-4000-8000-00000000008b	bc_bulk_139_2	7255	pos	2025-04-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000206	d1000001-0000-4000-8000-00000000008c	bc_bulk_140_2	7272	web	2025-04-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000020a	d1000001-0000-4000-8000-00000000008d	bc_bulk_141_2	7289	mobile	2025-04-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000020e	d1000001-0000-4000-8000-00000000008e	bc_bulk_142_2	7306	api	2025-04-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000212	d1000001-0000-4000-8000-00000000008f	bc_bulk_143_2	7323	pos	2025-04-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000216	d1000001-0000-4000-8000-000000000090	bc_bulk_144_2	7340	web	2025-04-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000021a	d1000001-0000-4000-8000-000000000091	bc_bulk_145_2	7357	mobile	2025-03-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000021e	d1000001-0000-4000-8000-000000000092	bc_bulk_146_2	7374	api	2025-03-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000222	d1000001-0000-4000-8000-000000000093	bc_bulk_147_2	7391	pos	2025-03-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000226	d1000001-0000-4000-8000-000000000094	bc_bulk_148_2	7408	web	2025-03-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000022a	d1000001-0000-4000-8000-000000000095	bc_bulk_149_2	7425	mobile	2025-03-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000022e	d1000001-0000-4000-8000-000000000096	bc_bulk_150_2	7442	api	2025-03-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000232	d1000001-0000-4000-8000-000000000097	bc_bulk_151_2	7459	pos	2025-02-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000236	d1000001-0000-4000-8000-000000000098	bc_bulk_152_2	7476	web	2026-02-23 11:38:31.520924+00
d3000005-0000-4000-8000-00000000023a	d1000001-0000-4000-8000-000000000099	bc_bulk_153_2	7493	mobile	2026-02-18 11:38:31.520924+00
d3000005-0000-4000-8000-00000000023e	d1000001-0000-4000-8000-00000000009a	bc_bulk_154_2	7510	api	2026-02-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000242	d1000001-0000-4000-8000-00000000009b	bc_bulk_155_2	7527	pos	2026-02-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000246	d1000001-0000-4000-8000-00000000009c	bc_bulk_156_2	7544	web	2026-02-03 11:38:31.520924+00
d3000005-0000-4000-8000-00000000024a	d1000001-0000-4000-8000-00000000009d	bc_bulk_157_2	7561	mobile	2026-01-29 11:38:31.520924+00
d3000005-0000-4000-8000-00000000024e	d1000001-0000-4000-8000-00000000009e	bc_bulk_158_2	7578	api	2026-01-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000252	d1000001-0000-4000-8000-00000000009f	bc_bulk_159_2	7595	pos	2026-01-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000256	d1000001-0000-4000-8000-0000000000a0	bc_bulk_160_2	7612	web	2026-01-14 11:38:31.520924+00
d3000005-0000-4000-8000-00000000025a	d1000001-0000-4000-8000-0000000000a1	bc_bulk_161_2	7629	mobile	2026-01-09 11:38:31.520924+00
d3000005-0000-4000-8000-00000000025e	d1000001-0000-4000-8000-0000000000a2	bc_bulk_162_2	7646	api	2026-01-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000262	d1000001-0000-4000-8000-0000000000a3	bc_bulk_163_2	7663	pos	2025-12-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000266	d1000001-0000-4000-8000-0000000000a4	bc_bulk_164_2	7680	web	2025-12-25 11:38:31.520924+00
d3000005-0000-4000-8000-00000000026a	d1000001-0000-4000-8000-0000000000a5	bc_bulk_165_2	7697	mobile	2025-12-20 11:38:31.520924+00
d3000005-0000-4000-8000-00000000026e	d1000001-0000-4000-8000-0000000000a6	bc_bulk_166_2	7714	api	2025-12-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000272	d1000001-0000-4000-8000-0000000000a7	bc_bulk_167_2	7731	pos	2025-12-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000276	d1000001-0000-4000-8000-0000000000a8	bc_bulk_168_2	7748	web	2025-12-05 11:38:31.520924+00
d3000005-0000-4000-8000-00000000027a	d1000001-0000-4000-8000-0000000000a9	bc_bulk_169_2	7765	mobile	2025-11-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000027e	d1000001-0000-4000-8000-0000000000aa	bc_bulk_170_2	7782	api	2025-11-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000282	d1000001-0000-4000-8000-0000000000ab	bc_bulk_171_2	7799	pos	2025-11-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000286	d1000001-0000-4000-8000-0000000000ac	bc_bulk_172_2	7816	web	2025-11-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000028a	d1000001-0000-4000-8000-0000000000ad	bc_bulk_173_2	7833	mobile	2025-11-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000028e	d1000001-0000-4000-8000-0000000000ae	bc_bulk_174_2	7850	api	2025-11-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000292	d1000001-0000-4000-8000-0000000000af	bc_bulk_175_2	7867	pos	2025-10-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000296	d1000001-0000-4000-8000-0000000000b0	bc_bulk_176_2	7884	web	2025-10-26 11:38:31.520924+00
d3000005-0000-4000-8000-00000000029a	d1000001-0000-4000-8000-0000000000b1	bc_bulk_177_2	7901	mobile	2025-10-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000029e	d1000001-0000-4000-8000-0000000000b2	bc_bulk_178_2	7918	api	2025-10-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a2	d1000001-0000-4000-8000-0000000000b3	bc_bulk_179_2	7935	pos	2025-10-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a6	d1000001-0000-4000-8000-0000000000b4	bc_bulk_180_2	7952	web	2025-10-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002aa	d1000001-0000-4000-8000-0000000000b5	bc_bulk_181_2	7969	mobile	2025-10-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ae	d1000001-0000-4000-8000-0000000000b6	bc_bulk_182_2	7986	api	2025-09-26 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b2	d1000001-0000-4000-8000-0000000000b7	bc_bulk_183_2	8003	pos	2025-09-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b6	d1000001-0000-4000-8000-0000000000b8	bc_bulk_184_2	8020	web	2025-09-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ba	d1000001-0000-4000-8000-0000000000b9	bc_bulk_185_2	8037	mobile	2025-09-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002be	d1000001-0000-4000-8000-0000000000ba	bc_bulk_186_2	8054	api	2025-09-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c2	d1000001-0000-4000-8000-0000000000bb	bc_bulk_187_2	8071	pos	2025-09-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c6	d1000001-0000-4000-8000-0000000000bc	bc_bulk_188_2	8088	web	2025-08-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ca	d1000001-0000-4000-8000-0000000000bd	bc_bulk_189_2	8105	mobile	2025-08-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ce	d1000001-0000-4000-8000-0000000000be	bc_bulk_190_2	8122	api	2025-08-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d2	d1000001-0000-4000-8000-0000000000bf	bc_bulk_191_2	8139	pos	2025-08-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d6	d1000001-0000-4000-8000-0000000000c0	bc_bulk_192_2	8156	web	2025-08-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002da	d1000001-0000-4000-8000-0000000000c1	bc_bulk_193_2	8173	mobile	2025-08-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002de	d1000001-0000-4000-8000-0000000000c2	bc_bulk_194_2	8190	api	2025-07-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e2	d1000001-0000-4000-8000-0000000000c3	bc_bulk_195_2	8207	pos	2025-07-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e6	d1000001-0000-4000-8000-0000000000c4	bc_bulk_196_2	8224	web	2025-07-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ea	d1000001-0000-4000-8000-0000000000c5	bc_bulk_197_2	8241	mobile	2025-07-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ee	d1000001-0000-4000-8000-0000000000c6	bc_bulk_198_2	8258	api	2025-07-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f2	d1000001-0000-4000-8000-0000000000c7	bc_bulk_199_2	8275	pos	2025-07-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f6	d1000001-0000-4000-8000-0000000000c8	bc_bulk_200_2	8292	web	2025-06-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002fa	d1000001-0000-4000-8000-0000000000c9	bc_bulk_201_2	8309	mobile	2025-06-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002fe	d1000001-0000-4000-8000-0000000000ca	bc_bulk_202_2	8326	api	2025-06-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000302	d1000001-0000-4000-8000-0000000000cb	bc_bulk_203_2	8343	pos	2025-06-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000306	d1000001-0000-4000-8000-0000000000cc	bc_bulk_204_2	8360	web	2025-06-08 11:38:31.520924+00
d3000005-0000-4000-8000-00000000030a	d1000001-0000-4000-8000-0000000000cd	bc_bulk_205_2	8377	mobile	2025-06-03 11:38:31.520924+00
d3000005-0000-4000-8000-00000000030e	d1000001-0000-4000-8000-0000000000ce	bc_bulk_206_2	8394	api	2025-05-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000312	d1000001-0000-4000-8000-0000000000cf	bc_bulk_207_2	8411	pos	2025-05-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000316	d1000001-0000-4000-8000-0000000000d0	bc_bulk_208_2	8428	web	2025-05-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000031a	d1000001-0000-4000-8000-0000000000d1	bc_bulk_209_2	8445	mobile	2025-05-14 11:38:31.520924+00
d3000005-0000-4000-8000-00000000031e	d1000001-0000-4000-8000-0000000000d2	bc_bulk_210_2	8462	api	2025-05-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000003	d1000001-0000-4000-8000-00000000000b	bc_bulk_11_3	5110	web	2026-01-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000007	d1000001-0000-4000-8000-00000000000c	bc_bulk_12_3	5127	mobile	2026-01-13 11:38:31.520924+00
d3000005-0000-4000-8000-00000000000b	d1000001-0000-4000-8000-00000000000d	bc_bulk_13_3	5144	api	2026-01-08 11:38:31.520924+00
d3000005-0000-4000-8000-00000000000f	d1000001-0000-4000-8000-00000000000e	bc_bulk_14_3	5161	pos	2026-01-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000013	d1000001-0000-4000-8000-00000000000f	bc_bulk_15_3	5178	web	2025-12-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000017	d1000001-0000-4000-8000-000000000010	bc_bulk_16_3	5195	mobile	2025-12-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000001b	d1000001-0000-4000-8000-000000000011	bc_bulk_17_3	5212	api	2025-12-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000001f	d1000001-0000-4000-8000-000000000012	bc_bulk_18_3	5229	pos	2025-12-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000023	d1000001-0000-4000-8000-000000000013	bc_bulk_19_3	5246	web	2025-12-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000027	d1000001-0000-4000-8000-000000000014	bc_bulk_20_3	5263	mobile	2025-12-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000002b	d1000001-0000-4000-8000-000000000015	bc_bulk_21_3	5280	api	2025-11-29 11:38:31.520924+00
d3000005-0000-4000-8000-00000000002f	d1000001-0000-4000-8000-000000000016	bc_bulk_22_3	5297	pos	2025-11-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000033	d1000001-0000-4000-8000-000000000017	bc_bulk_23_3	5314	web	2025-11-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000037	d1000001-0000-4000-8000-000000000018	bc_bulk_24_3	5331	mobile	2025-11-14 11:38:31.520924+00
d3000005-0000-4000-8000-00000000003b	d1000001-0000-4000-8000-000000000019	bc_bulk_25_3	5348	api	2025-11-09 11:38:31.520924+00
d3000005-0000-4000-8000-00000000003f	d1000001-0000-4000-8000-00000000001a	bc_bulk_26_3	5365	pos	2025-11-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000043	d1000001-0000-4000-8000-00000000001b	bc_bulk_27_3	5382	web	2025-10-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000047	d1000001-0000-4000-8000-00000000001c	bc_bulk_28_3	5399	mobile	2025-10-25 11:38:31.520924+00
d3000005-0000-4000-8000-00000000004b	d1000001-0000-4000-8000-00000000001d	bc_bulk_29_3	5416	api	2025-10-20 11:38:31.520924+00
d3000005-0000-4000-8000-00000000004f	d1000001-0000-4000-8000-00000000001e	bc_bulk_30_3	5433	pos	2025-10-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000053	d1000001-0000-4000-8000-00000000001f	bc_bulk_31_3	5450	web	2025-10-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000057	d1000001-0000-4000-8000-000000000020	bc_bulk_32_3	5467	mobile	2025-10-05 11:38:31.520924+00
d3000005-0000-4000-8000-00000000005b	d1000001-0000-4000-8000-000000000021	bc_bulk_33_3	5484	api	2025-09-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000005f	d1000001-0000-4000-8000-000000000022	bc_bulk_34_3	5501	pos	2025-09-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000063	d1000001-0000-4000-8000-000000000023	bc_bulk_35_3	5518	web	2025-09-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000067	d1000001-0000-4000-8000-000000000024	bc_bulk_36_3	5535	mobile	2025-09-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000006b	d1000001-0000-4000-8000-000000000025	bc_bulk_37_3	5552	api	2025-09-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000006f	d1000001-0000-4000-8000-000000000026	bc_bulk_38_3	5569	pos	2025-09-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000073	d1000001-0000-4000-8000-000000000027	bc_bulk_39_3	5586	web	2025-08-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000077	d1000001-0000-4000-8000-000000000028	bc_bulk_40_3	5603	mobile	2025-08-26 11:38:31.520924+00
d3000005-0000-4000-8000-00000000007b	d1000001-0000-4000-8000-000000000029	bc_bulk_41_3	5620	api	2025-08-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000007f	d1000001-0000-4000-8000-00000000002a	bc_bulk_42_3	5637	pos	2025-08-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000083	d1000001-0000-4000-8000-00000000002b	bc_bulk_43_3	5654	web	2025-08-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000087	d1000001-0000-4000-8000-00000000002c	bc_bulk_44_3	5671	mobile	2025-08-06 11:38:31.520924+00
d3000005-0000-4000-8000-00000000008b	d1000001-0000-4000-8000-00000000002d	bc_bulk_45_3	5688	api	2025-08-01 11:38:31.520924+00
d3000005-0000-4000-8000-00000000008f	d1000001-0000-4000-8000-00000000002e	bc_bulk_46_3	5705	pos	2025-07-27 11:38:31.520924+00
d3000005-0000-4000-8000-000000000093	d1000001-0000-4000-8000-00000000002f	bc_bulk_47_3	5722	web	2025-07-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000097	d1000001-0000-4000-8000-000000000030	bc_bulk_48_3	5739	mobile	2025-07-17 11:38:31.520924+00
d3000005-0000-4000-8000-00000000009b	d1000001-0000-4000-8000-000000000031	bc_bulk_49_3	5756	api	2025-07-12 11:38:31.520924+00
d3000005-0000-4000-8000-00000000009f	d1000001-0000-4000-8000-000000000032	bc_bulk_50_3	5773	pos	2025-07-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a3	d1000001-0000-4000-8000-000000000033	bc_bulk_51_3	5790	web	2025-07-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a7	d1000001-0000-4000-8000-000000000034	bc_bulk_52_3	5807	mobile	2025-06-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ab	d1000001-0000-4000-8000-000000000035	bc_bulk_53_3	5824	api	2025-06-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000af	d1000001-0000-4000-8000-000000000036	bc_bulk_54_3	5841	pos	2025-06-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b3	d1000001-0000-4000-8000-000000000037	bc_bulk_55_3	5858	web	2025-06-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b7	d1000001-0000-4000-8000-000000000038	bc_bulk_56_3	5875	mobile	2025-06-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000bb	d1000001-0000-4000-8000-000000000039	bc_bulk_57_3	5892	api	2025-06-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000bf	d1000001-0000-4000-8000-00000000003a	bc_bulk_58_3	5909	pos	2025-05-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c3	d1000001-0000-4000-8000-00000000003b	bc_bulk_59_3	5926	web	2025-05-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c7	d1000001-0000-4000-8000-00000000003c	bc_bulk_60_3	5943	mobile	2025-05-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000cb	d1000001-0000-4000-8000-00000000003d	bc_bulk_61_3	5960	api	2025-05-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000cf	d1000001-0000-4000-8000-00000000003e	bc_bulk_62_3	5977	pos	2025-05-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d3	d1000001-0000-4000-8000-00000000003f	bc_bulk_63_3	5994	web	2025-05-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d7	d1000001-0000-4000-8000-000000000040	bc_bulk_64_3	6011	mobile	2025-04-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000db	d1000001-0000-4000-8000-000000000041	bc_bulk_65_3	6028	api	2025-04-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000df	d1000001-0000-4000-8000-000000000042	bc_bulk_66_3	6045	pos	2025-04-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e3	d1000001-0000-4000-8000-000000000043	bc_bulk_67_3	6062	web	2025-04-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e7	d1000001-0000-4000-8000-000000000044	bc_bulk_68_3	6079	mobile	2025-04-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000eb	d1000001-0000-4000-8000-000000000045	bc_bulk_69_3	6096	api	2025-04-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ef	d1000001-0000-4000-8000-000000000046	bc_bulk_70_3	6113	pos	2025-03-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f3	d1000001-0000-4000-8000-000000000047	bc_bulk_71_3	6130	web	2025-03-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f7	d1000001-0000-4000-8000-000000000048	bc_bulk_72_3	6147	mobile	2025-03-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000fb	d1000001-0000-4000-8000-000000000049	bc_bulk_73_3	6164	api	2025-03-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ff	d1000001-0000-4000-8000-00000000004a	bc_bulk_74_3	6181	pos	2025-03-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000103	d1000001-0000-4000-8000-00000000004b	bc_bulk_75_3	6198	web	2025-03-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000107	d1000001-0000-4000-8000-00000000004c	bc_bulk_76_3	6215	mobile	2025-02-27 11:38:31.520924+00
d3000005-0000-4000-8000-00000000010b	d1000001-0000-4000-8000-00000000004d	bc_bulk_77_3	6232	api	2026-02-22 11:38:31.520924+00
d3000005-0000-4000-8000-00000000010f	d1000001-0000-4000-8000-00000000004e	bc_bulk_78_3	6249	pos	2026-02-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000113	d1000001-0000-4000-8000-00000000004f	bc_bulk_79_3	6266	web	2026-02-12 11:38:31.520924+00
d3000005-0000-4000-8000-000000000117	d1000001-0000-4000-8000-000000000050	bc_bulk_80_3	6283	mobile	2026-02-07 11:38:31.520924+00
d3000005-0000-4000-8000-00000000011b	d1000001-0000-4000-8000-000000000051	bc_bulk_81_3	6300	api	2026-02-02 11:38:31.520924+00
d3000005-0000-4000-8000-00000000011f	d1000001-0000-4000-8000-000000000052	bc_bulk_82_3	6317	pos	2026-01-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000123	d1000001-0000-4000-8000-000000000053	bc_bulk_83_3	6334	web	2026-01-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000127	d1000001-0000-4000-8000-000000000054	bc_bulk_84_3	6351	mobile	2026-01-18 11:38:31.520924+00
d3000005-0000-4000-8000-00000000012b	d1000001-0000-4000-8000-000000000055	bc_bulk_85_3	6368	api	2026-01-13 11:38:31.520924+00
d3000005-0000-4000-8000-00000000012f	d1000001-0000-4000-8000-000000000056	bc_bulk_86_3	6385	pos	2026-01-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000133	d1000001-0000-4000-8000-000000000057	bc_bulk_87_3	6402	web	2026-01-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000137	d1000001-0000-4000-8000-000000000058	bc_bulk_88_3	6419	mobile	2025-12-29 11:38:31.520924+00
d3000005-0000-4000-8000-00000000013b	d1000001-0000-4000-8000-000000000059	bc_bulk_89_3	6436	api	2025-12-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000013f	d1000001-0000-4000-8000-00000000005a	bc_bulk_90_3	6453	pos	2025-12-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000143	d1000001-0000-4000-8000-00000000005b	bc_bulk_91_3	6470	web	2025-12-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000147	d1000001-0000-4000-8000-00000000005c	bc_bulk_92_3	6487	mobile	2025-12-09 11:38:31.520924+00
d3000005-0000-4000-8000-00000000014b	d1000001-0000-4000-8000-00000000005d	bc_bulk_93_3	6504	api	2025-12-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000014f	d1000001-0000-4000-8000-00000000005e	bc_bulk_94_3	6521	pos	2025-11-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000153	d1000001-0000-4000-8000-00000000005f	bc_bulk_95_3	6538	web	2025-11-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000157	d1000001-0000-4000-8000-000000000060	bc_bulk_96_3	6555	mobile	2025-11-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000015b	d1000001-0000-4000-8000-000000000061	bc_bulk_97_3	6572	api	2025-11-14 11:38:31.520924+00
d3000005-0000-4000-8000-00000000015f	d1000001-0000-4000-8000-000000000062	bc_bulk_98_3	6589	pos	2025-11-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000163	d1000001-0000-4000-8000-000000000063	bc_bulk_99_3	6606	web	2025-11-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000167	d1000001-0000-4000-8000-000000000064	bc_bulk_100_3	6623	mobile	2025-10-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000016b	d1000001-0000-4000-8000-000000000065	bc_bulk_101_3	6640	api	2025-10-25 11:38:31.520924+00
d3000005-0000-4000-8000-00000000016f	d1000001-0000-4000-8000-000000000066	bc_bulk_102_3	6657	pos	2025-10-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000173	d1000001-0000-4000-8000-000000000067	bc_bulk_103_3	6674	web	2025-10-15 11:38:31.520924+00
d3000005-0000-4000-8000-000000000177	d1000001-0000-4000-8000-000000000068	bc_bulk_104_3	6691	mobile	2025-10-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000017b	d1000001-0000-4000-8000-000000000069	bc_bulk_105_3	6708	api	2025-10-05 11:38:31.520924+00
d3000005-0000-4000-8000-00000000017f	d1000001-0000-4000-8000-00000000006a	bc_bulk_106_3	6725	pos	2025-09-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000183	d1000001-0000-4000-8000-00000000006b	bc_bulk_107_3	6742	web	2025-09-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000187	d1000001-0000-4000-8000-00000000006c	bc_bulk_108_3	6759	mobile	2025-09-20 11:38:31.520924+00
d3000005-0000-4000-8000-00000000018b	d1000001-0000-4000-8000-00000000006d	bc_bulk_109_3	6776	api	2025-09-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000018f	d1000001-0000-4000-8000-00000000006e	bc_bulk_110_3	6793	pos	2025-09-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000193	d1000001-0000-4000-8000-00000000006f	bc_bulk_111_3	6810	web	2025-09-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000197	d1000001-0000-4000-8000-000000000070	bc_bulk_112_3	6827	mobile	2025-08-31 11:38:31.520924+00
d3000005-0000-4000-8000-00000000019b	d1000001-0000-4000-8000-000000000071	bc_bulk_113_3	6844	api	2025-08-26 11:38:31.520924+00
d3000005-0000-4000-8000-00000000019f	d1000001-0000-4000-8000-000000000072	bc_bulk_114_3	6861	pos	2025-08-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a3	d1000001-0000-4000-8000-000000000073	bc_bulk_115_3	6878	web	2025-08-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a7	d1000001-0000-4000-8000-000000000074	bc_bulk_116_3	6895	mobile	2025-08-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ab	d1000001-0000-4000-8000-000000000075	bc_bulk_117_3	6912	api	2025-08-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001af	d1000001-0000-4000-8000-000000000076	bc_bulk_118_3	6929	pos	2025-08-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b3	d1000001-0000-4000-8000-000000000077	bc_bulk_119_3	6946	web	2025-07-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b7	d1000001-0000-4000-8000-000000000078	bc_bulk_120_3	6963	mobile	2025-07-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001bb	d1000001-0000-4000-8000-000000000079	bc_bulk_121_3	6980	api	2025-07-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001bf	d1000001-0000-4000-8000-00000000007a	bc_bulk_122_3	6997	pos	2025-07-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c3	d1000001-0000-4000-8000-00000000007b	bc_bulk_123_3	7014	web	2025-07-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c7	d1000001-0000-4000-8000-00000000007c	bc_bulk_124_3	7031	mobile	2025-07-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001cb	d1000001-0000-4000-8000-00000000007d	bc_bulk_125_3	7048	api	2025-06-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001cf	d1000001-0000-4000-8000-00000000007e	bc_bulk_126_3	7065	pos	2025-06-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d3	d1000001-0000-4000-8000-00000000007f	bc_bulk_127_3	7082	web	2025-06-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d7	d1000001-0000-4000-8000-000000000080	bc_bulk_128_3	7099	mobile	2025-06-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001db	d1000001-0000-4000-8000-000000000081	bc_bulk_129_3	7116	api	2025-06-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001df	d1000001-0000-4000-8000-000000000082	bc_bulk_130_3	7133	pos	2025-06-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e3	d1000001-0000-4000-8000-000000000083	bc_bulk_131_3	7150	web	2025-05-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e7	d1000001-0000-4000-8000-000000000084	bc_bulk_132_3	7167	mobile	2025-05-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001eb	d1000001-0000-4000-8000-000000000085	bc_bulk_133_3	7184	api	2025-05-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ef	d1000001-0000-4000-8000-000000000086	bc_bulk_134_3	7201	pos	2025-05-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f3	d1000001-0000-4000-8000-000000000087	bc_bulk_135_3	7218	web	2025-05-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f7	d1000001-0000-4000-8000-000000000088	bc_bulk_136_3	7235	mobile	2025-05-03 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001fb	d1000001-0000-4000-8000-000000000089	bc_bulk_137_3	7252	api	2025-04-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ff	d1000001-0000-4000-8000-00000000008a	bc_bulk_138_3	7269	pos	2025-04-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000203	d1000001-0000-4000-8000-00000000008b	bc_bulk_139_3	7286	web	2025-04-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000207	d1000001-0000-4000-8000-00000000008c	bc_bulk_140_3	7303	mobile	2025-04-13 11:38:31.520924+00
d3000005-0000-4000-8000-00000000020b	d1000001-0000-4000-8000-00000000008d	bc_bulk_141_3	7320	api	2025-04-08 11:38:31.520924+00
d3000005-0000-4000-8000-00000000020f	d1000001-0000-4000-8000-00000000008e	bc_bulk_142_3	7337	pos	2025-04-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000213	d1000001-0000-4000-8000-00000000008f	bc_bulk_143_3	7354	web	2025-03-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000217	d1000001-0000-4000-8000-000000000090	bc_bulk_144_3	7371	mobile	2025-03-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000021b	d1000001-0000-4000-8000-000000000091	bc_bulk_145_3	7388	api	2025-03-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000021f	d1000001-0000-4000-8000-000000000092	bc_bulk_146_3	7405	pos	2025-03-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000223	d1000001-0000-4000-8000-000000000093	bc_bulk_147_3	7422	web	2025-03-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000227	d1000001-0000-4000-8000-000000000094	bc_bulk_148_3	7439	mobile	2025-03-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000022b	d1000001-0000-4000-8000-000000000095	bc_bulk_149_3	7456	api	2025-02-27 11:38:31.520924+00
d3000005-0000-4000-8000-00000000022f	d1000001-0000-4000-8000-000000000096	bc_bulk_150_3	7473	pos	2026-02-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000233	d1000001-0000-4000-8000-000000000097	bc_bulk_151_3	7490	web	2026-02-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000237	d1000001-0000-4000-8000-000000000098	bc_bulk_152_3	7507	mobile	2026-02-12 11:38:31.520924+00
d3000005-0000-4000-8000-00000000023b	d1000001-0000-4000-8000-000000000099	bc_bulk_153_3	7524	api	2026-02-07 11:38:31.520924+00
d3000005-0000-4000-8000-00000000023f	d1000001-0000-4000-8000-00000000009a	bc_bulk_154_3	7541	pos	2026-02-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000243	d1000001-0000-4000-8000-00000000009b	bc_bulk_155_3	7558	web	2026-01-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000247	d1000001-0000-4000-8000-00000000009c	bc_bulk_156_3	7575	mobile	2026-01-23 11:38:31.520924+00
d3000005-0000-4000-8000-00000000024b	d1000001-0000-4000-8000-00000000009d	bc_bulk_157_3	7592	api	2026-01-18 11:38:31.520924+00
d3000005-0000-4000-8000-00000000024f	d1000001-0000-4000-8000-00000000009e	bc_bulk_158_3	7609	pos	2026-01-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000253	d1000001-0000-4000-8000-00000000009f	bc_bulk_159_3	7626	web	2026-01-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000257	d1000001-0000-4000-8000-0000000000a0	bc_bulk_160_3	7643	mobile	2026-01-03 11:38:31.520924+00
d3000005-0000-4000-8000-00000000025b	d1000001-0000-4000-8000-0000000000a1	bc_bulk_161_3	7660	api	2025-12-29 11:38:31.520924+00
d3000005-0000-4000-8000-00000000025f	d1000001-0000-4000-8000-0000000000a2	bc_bulk_162_3	7677	pos	2025-12-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000263	d1000001-0000-4000-8000-0000000000a3	bc_bulk_163_3	7694	web	2025-12-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000267	d1000001-0000-4000-8000-0000000000a4	bc_bulk_164_3	7711	mobile	2025-12-14 11:38:31.520924+00
d3000005-0000-4000-8000-00000000026b	d1000001-0000-4000-8000-0000000000a5	bc_bulk_165_3	7728	api	2025-12-09 11:38:31.520924+00
d3000005-0000-4000-8000-00000000026f	d1000001-0000-4000-8000-0000000000a6	bc_bulk_166_3	7745	pos	2025-12-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000273	d1000001-0000-4000-8000-0000000000a7	bc_bulk_167_3	7762	web	2025-11-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000277	d1000001-0000-4000-8000-0000000000a8	bc_bulk_168_3	7779	mobile	2025-11-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000027b	d1000001-0000-4000-8000-0000000000a9	bc_bulk_169_3	7796	api	2025-11-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000027f	d1000001-0000-4000-8000-0000000000aa	bc_bulk_170_3	7813	pos	2025-11-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000283	d1000001-0000-4000-8000-0000000000ab	bc_bulk_171_3	7830	web	2025-11-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000287	d1000001-0000-4000-8000-0000000000ac	bc_bulk_172_3	7847	mobile	2025-11-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000028b	d1000001-0000-4000-8000-0000000000ad	bc_bulk_173_3	7864	api	2025-10-30 11:38:31.520924+00
d3000005-0000-4000-8000-00000000028f	d1000001-0000-4000-8000-0000000000ae	bc_bulk_174_3	7881	pos	2025-10-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000293	d1000001-0000-4000-8000-0000000000af	bc_bulk_175_3	7898	web	2025-10-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000297	d1000001-0000-4000-8000-0000000000b0	bc_bulk_176_3	7915	mobile	2025-10-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000029b	d1000001-0000-4000-8000-0000000000b1	bc_bulk_177_3	7932	api	2025-10-10 11:38:31.520924+00
d3000005-0000-4000-8000-00000000029f	d1000001-0000-4000-8000-0000000000b2	bc_bulk_178_3	7949	pos	2025-10-05 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a3	d1000001-0000-4000-8000-0000000000b3	bc_bulk_179_3	7966	web	2025-09-30 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a7	d1000001-0000-4000-8000-0000000000b4	bc_bulk_180_3	7983	mobile	2025-09-25 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ab	d1000001-0000-4000-8000-0000000000b5	bc_bulk_181_3	8000	api	2025-09-20 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002af	d1000001-0000-4000-8000-0000000000b6	bc_bulk_182_3	8017	pos	2025-09-15 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b3	d1000001-0000-4000-8000-0000000000b7	bc_bulk_183_3	8034	web	2025-09-10 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b7	d1000001-0000-4000-8000-0000000000b8	bc_bulk_184_3	8051	mobile	2025-09-05 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002bb	d1000001-0000-4000-8000-0000000000b9	bc_bulk_185_3	8068	api	2025-08-31 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002bf	d1000001-0000-4000-8000-0000000000ba	bc_bulk_186_3	8085	pos	2025-08-26 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c3	d1000001-0000-4000-8000-0000000000bb	bc_bulk_187_3	8102	web	2025-08-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c7	d1000001-0000-4000-8000-0000000000bc	bc_bulk_188_3	8119	mobile	2025-08-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002cb	d1000001-0000-4000-8000-0000000000bd	bc_bulk_189_3	8136	api	2025-08-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002cf	d1000001-0000-4000-8000-0000000000be	bc_bulk_190_3	8153	pos	2025-08-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d3	d1000001-0000-4000-8000-0000000000bf	bc_bulk_191_3	8170	web	2025-08-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d7	d1000001-0000-4000-8000-0000000000c0	bc_bulk_192_3	8187	mobile	2025-07-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002db	d1000001-0000-4000-8000-0000000000c1	bc_bulk_193_3	8204	api	2025-07-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002df	d1000001-0000-4000-8000-0000000000c2	bc_bulk_194_3	8221	pos	2025-07-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e3	d1000001-0000-4000-8000-0000000000c3	bc_bulk_195_3	8238	web	2025-07-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e7	d1000001-0000-4000-8000-0000000000c4	bc_bulk_196_3	8255	mobile	2025-07-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002eb	d1000001-0000-4000-8000-0000000000c5	bc_bulk_197_3	8272	api	2025-07-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ef	d1000001-0000-4000-8000-0000000000c6	bc_bulk_198_3	8289	pos	2025-06-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f3	d1000001-0000-4000-8000-0000000000c7	bc_bulk_199_3	8306	web	2025-06-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f7	d1000001-0000-4000-8000-0000000000c8	bc_bulk_200_3	8323	mobile	2025-06-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002fb	d1000001-0000-4000-8000-0000000000c9	bc_bulk_201_3	8340	api	2025-06-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ff	d1000001-0000-4000-8000-0000000000ca	bc_bulk_202_3	8357	pos	2025-06-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000303	d1000001-0000-4000-8000-0000000000cb	bc_bulk_203_3	8374	web	2025-06-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000307	d1000001-0000-4000-8000-0000000000cc	bc_bulk_204_3	8391	mobile	2025-05-28 11:38:31.520924+00
d3000005-0000-4000-8000-00000000030b	d1000001-0000-4000-8000-0000000000cd	bc_bulk_205_3	8408	api	2025-05-23 11:38:31.520924+00
d3000005-0000-4000-8000-00000000030f	d1000001-0000-4000-8000-0000000000ce	bc_bulk_206_3	8425	pos	2025-05-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000313	d1000001-0000-4000-8000-0000000000cf	bc_bulk_207_3	8442	web	2025-05-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000317	d1000001-0000-4000-8000-0000000000d0	bc_bulk_208_3	8459	mobile	2025-05-08 11:38:31.520924+00
d3000005-0000-4000-8000-00000000031b	d1000001-0000-4000-8000-0000000000d1	bc_bulk_209_3	8476	api	2025-05-03 11:38:31.520924+00
d3000005-0000-4000-8000-00000000031f	d1000001-0000-4000-8000-0000000000d2	bc_bulk_210_3	8493	pos	2025-04-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000004	d1000001-0000-4000-8000-00000000000b	bc_bulk_11_4	5141	mobile	2026-01-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000008	d1000001-0000-4000-8000-00000000000c	bc_bulk_12_4	5158	api	2026-01-02 11:38:31.520924+00
d3000005-0000-4000-8000-00000000000c	d1000001-0000-4000-8000-00000000000d	bc_bulk_13_4	5175	pos	2025-12-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000010	d1000001-0000-4000-8000-00000000000e	bc_bulk_14_4	5192	web	2025-12-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000014	d1000001-0000-4000-8000-00000000000f	bc_bulk_15_4	5209	mobile	2025-12-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000018	d1000001-0000-4000-8000-000000000010	bc_bulk_16_4	5226	api	2025-12-13 11:38:31.520924+00
d3000005-0000-4000-8000-00000000001c	d1000001-0000-4000-8000-000000000011	bc_bulk_17_4	5243	pos	2025-12-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000020	d1000001-0000-4000-8000-000000000012	bc_bulk_18_4	5260	web	2025-12-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000024	d1000001-0000-4000-8000-000000000013	bc_bulk_19_4	5277	mobile	2025-11-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000028	d1000001-0000-4000-8000-000000000014	bc_bulk_20_4	5294	api	2025-11-23 11:38:31.520924+00
d3000005-0000-4000-8000-00000000002c	d1000001-0000-4000-8000-000000000015	bc_bulk_21_4	5311	pos	2025-11-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000030	d1000001-0000-4000-8000-000000000016	bc_bulk_22_4	5328	web	2025-11-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000034	d1000001-0000-4000-8000-000000000017	bc_bulk_23_4	5345	mobile	2025-11-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000038	d1000001-0000-4000-8000-000000000018	bc_bulk_24_4	5362	api	2025-11-03 11:38:31.520924+00
d3000005-0000-4000-8000-00000000003c	d1000001-0000-4000-8000-000000000019	bc_bulk_25_4	5379	pos	2025-10-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000040	d1000001-0000-4000-8000-00000000001a	bc_bulk_26_4	5396	web	2025-10-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000044	d1000001-0000-4000-8000-00000000001b	bc_bulk_27_4	5413	mobile	2025-10-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000048	d1000001-0000-4000-8000-00000000001c	bc_bulk_28_4	5430	api	2025-10-14 11:38:31.520924+00
d3000005-0000-4000-8000-00000000004c	d1000001-0000-4000-8000-00000000001d	bc_bulk_29_4	5447	pos	2025-10-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000050	d1000001-0000-4000-8000-00000000001e	bc_bulk_30_4	5464	web	2025-10-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000054	d1000001-0000-4000-8000-00000000001f	bc_bulk_31_4	5481	mobile	2025-09-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000058	d1000001-0000-4000-8000-000000000020	bc_bulk_32_4	5498	api	2025-09-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000005c	d1000001-0000-4000-8000-000000000021	bc_bulk_33_4	5515	pos	2025-09-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000060	d1000001-0000-4000-8000-000000000022	bc_bulk_34_4	5532	web	2025-09-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000064	d1000001-0000-4000-8000-000000000023	bc_bulk_35_4	5549	mobile	2025-09-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000068	d1000001-0000-4000-8000-000000000024	bc_bulk_36_4	5566	api	2025-09-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000006c	d1000001-0000-4000-8000-000000000025	bc_bulk_37_4	5583	pos	2025-08-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000070	d1000001-0000-4000-8000-000000000026	bc_bulk_38_4	5600	web	2025-08-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000074	d1000001-0000-4000-8000-000000000027	bc_bulk_39_4	5617	mobile	2025-08-20 11:38:31.520924+00
d3000005-0000-4000-8000-000000000078	d1000001-0000-4000-8000-000000000028	bc_bulk_40_4	5634	api	2025-08-15 11:38:31.520924+00
d3000005-0000-4000-8000-00000000007c	d1000001-0000-4000-8000-000000000029	bc_bulk_41_4	5651	pos	2025-08-10 11:38:31.520924+00
d3000005-0000-4000-8000-000000000080	d1000001-0000-4000-8000-00000000002a	bc_bulk_42_4	5668	web	2025-08-05 11:38:31.520924+00
d3000005-0000-4000-8000-000000000084	d1000001-0000-4000-8000-00000000002b	bc_bulk_43_4	5685	mobile	2025-07-31 11:38:31.520924+00
d3000005-0000-4000-8000-000000000088	d1000001-0000-4000-8000-00000000002c	bc_bulk_44_4	5702	api	2025-07-26 11:38:31.520924+00
d3000005-0000-4000-8000-00000000008c	d1000001-0000-4000-8000-00000000002d	bc_bulk_45_4	5719	pos	2025-07-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000090	d1000001-0000-4000-8000-00000000002e	bc_bulk_46_4	5736	web	2025-07-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000094	d1000001-0000-4000-8000-00000000002f	bc_bulk_47_4	5753	mobile	2025-07-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000098	d1000001-0000-4000-8000-000000000030	bc_bulk_48_4	5770	api	2025-07-06 11:38:31.520924+00
d3000005-0000-4000-8000-00000000009c	d1000001-0000-4000-8000-000000000031	bc_bulk_49_4	5787	pos	2025-07-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a0	d1000001-0000-4000-8000-000000000032	bc_bulk_50_4	5804	web	2025-06-26 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a4	d1000001-0000-4000-8000-000000000033	bc_bulk_51_4	5821	mobile	2025-06-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000a8	d1000001-0000-4000-8000-000000000034	bc_bulk_52_4	5838	api	2025-06-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ac	d1000001-0000-4000-8000-000000000035	bc_bulk_53_4	5855	pos	2025-06-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b0	d1000001-0000-4000-8000-000000000036	bc_bulk_54_4	5872	web	2025-06-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b4	d1000001-0000-4000-8000-000000000037	bc_bulk_55_4	5889	mobile	2025-06-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000b8	d1000001-0000-4000-8000-000000000038	bc_bulk_56_4	5906	api	2025-05-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000bc	d1000001-0000-4000-8000-000000000039	bc_bulk_57_4	5923	pos	2025-05-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c0	d1000001-0000-4000-8000-00000000003a	bc_bulk_58_4	5940	web	2025-05-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c4	d1000001-0000-4000-8000-00000000003b	bc_bulk_59_4	5957	mobile	2025-05-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000c8	d1000001-0000-4000-8000-00000000003c	bc_bulk_60_4	5974	api	2025-05-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000cc	d1000001-0000-4000-8000-00000000003d	bc_bulk_61_4	5991	pos	2025-05-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d0	d1000001-0000-4000-8000-00000000003e	bc_bulk_62_4	6008	web	2025-04-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d4	d1000001-0000-4000-8000-00000000003f	bc_bulk_63_4	6025	mobile	2025-04-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000d8	d1000001-0000-4000-8000-000000000040	bc_bulk_64_4	6042	api	2025-04-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000dc	d1000001-0000-4000-8000-000000000041	bc_bulk_65_4	6059	pos	2025-04-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e0	d1000001-0000-4000-8000-000000000042	bc_bulk_66_4	6076	web	2025-04-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e4	d1000001-0000-4000-8000-000000000043	bc_bulk_67_4	6093	mobile	2025-04-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000e8	d1000001-0000-4000-8000-000000000044	bc_bulk_68_4	6110	api	2025-03-28 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000ec	d1000001-0000-4000-8000-000000000045	bc_bulk_69_4	6127	pos	2025-03-23 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f0	d1000001-0000-4000-8000-000000000046	bc_bulk_70_4	6144	web	2025-03-18 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f4	d1000001-0000-4000-8000-000000000047	bc_bulk_71_4	6161	mobile	2025-03-13 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000f8	d1000001-0000-4000-8000-000000000048	bc_bulk_72_4	6178	api	2025-03-08 11:38:31.520924+00
d3000005-0000-4000-8000-0000000000fc	d1000001-0000-4000-8000-000000000049	bc_bulk_73_4	6195	pos	2025-03-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000100	d1000001-0000-4000-8000-00000000004a	bc_bulk_74_4	6212	web	2025-02-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000104	d1000001-0000-4000-8000-00000000004b	bc_bulk_75_4	6229	mobile	2026-02-21 11:38:31.520924+00
d3000005-0000-4000-8000-000000000108	d1000001-0000-4000-8000-00000000004c	bc_bulk_76_4	6246	api	2026-02-16 11:38:31.520924+00
d3000005-0000-4000-8000-00000000010c	d1000001-0000-4000-8000-00000000004d	bc_bulk_77_4	6263	pos	2026-02-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000110	d1000001-0000-4000-8000-00000000004e	bc_bulk_78_4	6280	web	2026-02-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000114	d1000001-0000-4000-8000-00000000004f	bc_bulk_79_4	6297	mobile	2026-02-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000118	d1000001-0000-4000-8000-000000000050	bc_bulk_80_4	6314	api	2026-01-27 11:38:31.520924+00
d3000005-0000-4000-8000-00000000011c	d1000001-0000-4000-8000-000000000051	bc_bulk_81_4	6331	pos	2026-01-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000120	d1000001-0000-4000-8000-000000000052	bc_bulk_82_4	6348	web	2026-01-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000124	d1000001-0000-4000-8000-000000000053	bc_bulk_83_4	6365	mobile	2026-01-12 11:38:31.520924+00
d3000005-0000-4000-8000-000000000128	d1000001-0000-4000-8000-000000000054	bc_bulk_84_4	6382	api	2026-01-07 11:38:31.520924+00
d3000005-0000-4000-8000-00000000012c	d1000001-0000-4000-8000-000000000055	bc_bulk_85_4	6399	pos	2026-01-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000130	d1000001-0000-4000-8000-000000000056	bc_bulk_86_4	6416	web	2025-12-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000134	d1000001-0000-4000-8000-000000000057	bc_bulk_87_4	6433	mobile	2025-12-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000138	d1000001-0000-4000-8000-000000000058	bc_bulk_88_4	6450	api	2025-12-18 11:38:31.520924+00
d3000005-0000-4000-8000-00000000013c	d1000001-0000-4000-8000-000000000059	bc_bulk_89_4	6467	pos	2025-12-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000140	d1000001-0000-4000-8000-00000000005a	bc_bulk_90_4	6484	web	2025-12-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000144	d1000001-0000-4000-8000-00000000005b	bc_bulk_91_4	6501	mobile	2025-12-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000148	d1000001-0000-4000-8000-00000000005c	bc_bulk_92_4	6518	api	2025-11-28 11:38:31.520924+00
d3000005-0000-4000-8000-00000000014c	d1000001-0000-4000-8000-00000000005d	bc_bulk_93_4	6535	pos	2025-11-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000150	d1000001-0000-4000-8000-00000000005e	bc_bulk_94_4	6552	web	2025-11-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000154	d1000001-0000-4000-8000-00000000005f	bc_bulk_95_4	6569	mobile	2025-11-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000158	d1000001-0000-4000-8000-000000000060	bc_bulk_96_4	6586	api	2025-11-08 11:38:31.520924+00
d3000005-0000-4000-8000-00000000015c	d1000001-0000-4000-8000-000000000061	bc_bulk_97_4	6603	pos	2025-11-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000160	d1000001-0000-4000-8000-000000000062	bc_bulk_98_4	6620	web	2025-10-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000164	d1000001-0000-4000-8000-000000000063	bc_bulk_99_4	6637	mobile	2025-10-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000168	d1000001-0000-4000-8000-000000000064	bc_bulk_100_4	6654	api	2025-10-19 11:38:31.520924+00
d3000005-0000-4000-8000-00000000016c	d1000001-0000-4000-8000-000000000065	bc_bulk_101_4	6671	pos	2025-10-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000170	d1000001-0000-4000-8000-000000000066	bc_bulk_102_4	6688	web	2025-10-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000174	d1000001-0000-4000-8000-000000000067	bc_bulk_103_4	6705	mobile	2025-10-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000178	d1000001-0000-4000-8000-000000000068	bc_bulk_104_4	6722	api	2025-09-29 11:38:31.520924+00
d3000005-0000-4000-8000-00000000017c	d1000001-0000-4000-8000-000000000069	bc_bulk_105_4	6739	pos	2025-09-24 11:38:31.520924+00
d3000005-0000-4000-8000-000000000180	d1000001-0000-4000-8000-00000000006a	bc_bulk_106_4	6756	web	2025-09-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000184	d1000001-0000-4000-8000-00000000006b	bc_bulk_107_4	6773	mobile	2025-09-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000188	d1000001-0000-4000-8000-00000000006c	bc_bulk_108_4	6790	api	2025-09-09 11:38:31.520924+00
d3000005-0000-4000-8000-00000000018c	d1000001-0000-4000-8000-00000000006d	bc_bulk_109_4	6807	pos	2025-09-04 11:38:31.520924+00
d3000005-0000-4000-8000-000000000190	d1000001-0000-4000-8000-00000000006e	bc_bulk_110_4	6824	web	2025-08-30 11:38:31.520924+00
d3000005-0000-4000-8000-000000000194	d1000001-0000-4000-8000-00000000006f	bc_bulk_111_4	6841	mobile	2025-08-25 11:38:31.520924+00
d3000005-0000-4000-8000-000000000198	d1000001-0000-4000-8000-000000000070	bc_bulk_112_4	6858	api	2025-08-20 11:38:31.520924+00
d3000005-0000-4000-8000-00000000019c	d1000001-0000-4000-8000-000000000071	bc_bulk_113_4	6875	pos	2025-08-15 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a0	d1000001-0000-4000-8000-000000000072	bc_bulk_114_4	6892	web	2025-08-10 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a4	d1000001-0000-4000-8000-000000000073	bc_bulk_115_4	6909	mobile	2025-08-05 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001a8	d1000001-0000-4000-8000-000000000074	bc_bulk_116_4	6926	api	2025-07-31 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ac	d1000001-0000-4000-8000-000000000075	bc_bulk_117_4	6943	pos	2025-07-26 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b0	d1000001-0000-4000-8000-000000000076	bc_bulk_118_4	6960	web	2025-07-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b4	d1000001-0000-4000-8000-000000000077	bc_bulk_119_4	6977	mobile	2025-07-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001b8	d1000001-0000-4000-8000-000000000078	bc_bulk_120_4	6994	api	2025-07-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001bc	d1000001-0000-4000-8000-000000000079	bc_bulk_121_4	7011	pos	2025-07-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c0	d1000001-0000-4000-8000-00000000007a	bc_bulk_122_4	7028	web	2025-07-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c4	d1000001-0000-4000-8000-00000000007b	bc_bulk_123_4	7045	mobile	2025-06-26 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001c8	d1000001-0000-4000-8000-00000000007c	bc_bulk_124_4	7062	api	2025-06-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001cc	d1000001-0000-4000-8000-00000000007d	bc_bulk_125_4	7079	pos	2025-06-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d0	d1000001-0000-4000-8000-00000000007e	bc_bulk_126_4	7096	web	2025-06-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d4	d1000001-0000-4000-8000-00000000007f	bc_bulk_127_4	7113	mobile	2025-06-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001d8	d1000001-0000-4000-8000-000000000080	bc_bulk_128_4	7130	api	2025-06-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001dc	d1000001-0000-4000-8000-000000000081	bc_bulk_129_4	7147	pos	2025-05-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e0	d1000001-0000-4000-8000-000000000082	bc_bulk_130_4	7164	web	2025-05-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e4	d1000001-0000-4000-8000-000000000083	bc_bulk_131_4	7181	mobile	2025-05-17 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001e8	d1000001-0000-4000-8000-000000000084	bc_bulk_132_4	7198	api	2025-05-12 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001ec	d1000001-0000-4000-8000-000000000085	bc_bulk_133_4	7215	pos	2025-05-07 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f0	d1000001-0000-4000-8000-000000000086	bc_bulk_134_4	7232	web	2025-05-02 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f4	d1000001-0000-4000-8000-000000000087	bc_bulk_135_4	7249	mobile	2025-04-27 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001f8	d1000001-0000-4000-8000-000000000088	bc_bulk_136_4	7266	api	2025-04-22 11:38:31.520924+00
d3000005-0000-4000-8000-0000000001fc	d1000001-0000-4000-8000-000000000089	bc_bulk_137_4	7283	pos	2025-04-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000200	d1000001-0000-4000-8000-00000000008a	bc_bulk_138_4	7300	web	2025-04-12 11:38:31.520924+00
d3000005-0000-4000-8000-000000000204	d1000001-0000-4000-8000-00000000008b	bc_bulk_139_4	7317	mobile	2025-04-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000208	d1000001-0000-4000-8000-00000000008c	bc_bulk_140_4	7334	api	2025-04-02 11:38:31.520924+00
d3000005-0000-4000-8000-00000000020c	d1000001-0000-4000-8000-00000000008d	bc_bulk_141_4	7351	pos	2025-03-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000210	d1000001-0000-4000-8000-00000000008e	bc_bulk_142_4	7368	web	2025-03-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000214	d1000001-0000-4000-8000-00000000008f	bc_bulk_143_4	7385	mobile	2025-03-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000218	d1000001-0000-4000-8000-000000000090	bc_bulk_144_4	7402	api	2025-03-13 11:38:31.520924+00
d3000005-0000-4000-8000-00000000021c	d1000001-0000-4000-8000-000000000091	bc_bulk_145_4	7419	pos	2025-03-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000220	d1000001-0000-4000-8000-000000000092	bc_bulk_146_4	7436	web	2025-03-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000224	d1000001-0000-4000-8000-000000000093	bc_bulk_147_4	7453	mobile	2025-02-26 11:38:31.520924+00
d3000005-0000-4000-8000-000000000228	d1000001-0000-4000-8000-000000000094	bc_bulk_148_4	7470	api	2026-02-21 11:38:31.520924+00
d3000005-0000-4000-8000-00000000022c	d1000001-0000-4000-8000-000000000095	bc_bulk_149_4	7487	pos	2026-02-16 11:38:31.520924+00
d3000005-0000-4000-8000-000000000230	d1000001-0000-4000-8000-000000000096	bc_bulk_150_4	7504	web	2026-02-11 11:38:31.520924+00
d3000005-0000-4000-8000-000000000234	d1000001-0000-4000-8000-000000000097	bc_bulk_151_4	7521	mobile	2026-02-06 11:38:31.520924+00
d3000005-0000-4000-8000-000000000238	d1000001-0000-4000-8000-000000000098	bc_bulk_152_4	7538	api	2026-02-01 11:38:31.520924+00
d3000005-0000-4000-8000-00000000023c	d1000001-0000-4000-8000-000000000099	bc_bulk_153_4	7555	pos	2026-01-27 11:38:31.520924+00
d3000005-0000-4000-8000-000000000240	d1000001-0000-4000-8000-00000000009a	bc_bulk_154_4	7572	web	2026-01-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000244	d1000001-0000-4000-8000-00000000009b	bc_bulk_155_4	7589	mobile	2026-01-17 11:38:31.520924+00
d3000005-0000-4000-8000-000000000248	d1000001-0000-4000-8000-00000000009c	bc_bulk_156_4	7606	api	2026-01-12 11:38:31.520924+00
d3000005-0000-4000-8000-00000000024c	d1000001-0000-4000-8000-00000000009d	bc_bulk_157_4	7623	pos	2026-01-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000250	d1000001-0000-4000-8000-00000000009e	bc_bulk_158_4	7640	web	2026-01-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000254	d1000001-0000-4000-8000-00000000009f	bc_bulk_159_4	7657	mobile	2025-12-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000258	d1000001-0000-4000-8000-0000000000a0	bc_bulk_160_4	7674	api	2025-12-23 11:38:31.520924+00
d3000005-0000-4000-8000-00000000025c	d1000001-0000-4000-8000-0000000000a1	bc_bulk_161_4	7691	pos	2025-12-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000260	d1000001-0000-4000-8000-0000000000a2	bc_bulk_162_4	7708	web	2025-12-13 11:38:31.520924+00
d3000005-0000-4000-8000-000000000264	d1000001-0000-4000-8000-0000000000a3	bc_bulk_163_4	7725	mobile	2025-12-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000268	d1000001-0000-4000-8000-0000000000a4	bc_bulk_164_4	7742	api	2025-12-03 11:38:31.520924+00
d3000005-0000-4000-8000-00000000026c	d1000001-0000-4000-8000-0000000000a5	bc_bulk_165_4	7759	pos	2025-11-28 11:38:31.520924+00
d3000005-0000-4000-8000-000000000270	d1000001-0000-4000-8000-0000000000a6	bc_bulk_166_4	7776	web	2025-11-23 11:38:31.520924+00
d3000005-0000-4000-8000-000000000274	d1000001-0000-4000-8000-0000000000a7	bc_bulk_167_4	7793	mobile	2025-11-18 11:38:31.520924+00
d3000005-0000-4000-8000-000000000278	d1000001-0000-4000-8000-0000000000a8	bc_bulk_168_4	7810	api	2025-11-13 11:38:31.520924+00
d3000005-0000-4000-8000-00000000027c	d1000001-0000-4000-8000-0000000000a9	bc_bulk_169_4	7827	pos	2025-11-08 11:38:31.520924+00
d3000005-0000-4000-8000-000000000280	d1000001-0000-4000-8000-0000000000aa	bc_bulk_170_4	7844	web	2025-11-03 11:38:31.520924+00
d3000005-0000-4000-8000-000000000284	d1000001-0000-4000-8000-0000000000ab	bc_bulk_171_4	7861	mobile	2025-10-29 11:38:31.520924+00
d3000005-0000-4000-8000-000000000288	d1000001-0000-4000-8000-0000000000ac	bc_bulk_172_4	7878	api	2025-10-24 11:38:31.520924+00
d3000005-0000-4000-8000-00000000028c	d1000001-0000-4000-8000-0000000000ad	bc_bulk_173_4	7895	pos	2025-10-19 11:38:31.520924+00
d3000005-0000-4000-8000-000000000290	d1000001-0000-4000-8000-0000000000ae	bc_bulk_174_4	7912	web	2025-10-14 11:38:31.520924+00
d3000005-0000-4000-8000-000000000294	d1000001-0000-4000-8000-0000000000af	bc_bulk_175_4	7929	mobile	2025-10-09 11:38:31.520924+00
d3000005-0000-4000-8000-000000000298	d1000001-0000-4000-8000-0000000000b0	bc_bulk_176_4	7946	api	2025-10-04 11:38:31.520924+00
d3000005-0000-4000-8000-00000000029c	d1000001-0000-4000-8000-0000000000b1	bc_bulk_177_4	7963	pos	2025-09-29 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a0	d1000001-0000-4000-8000-0000000000b2	bc_bulk_178_4	7980	web	2025-09-24 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a4	d1000001-0000-4000-8000-0000000000b3	bc_bulk_179_4	7997	mobile	2025-09-19 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002a8	d1000001-0000-4000-8000-0000000000b4	bc_bulk_180_4	8014	api	2025-09-14 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ac	d1000001-0000-4000-8000-0000000000b5	bc_bulk_181_4	8031	pos	2025-09-09 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b0	d1000001-0000-4000-8000-0000000000b6	bc_bulk_182_4	8048	web	2025-09-04 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b4	d1000001-0000-4000-8000-0000000000b7	bc_bulk_183_4	8065	mobile	2025-08-30 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002b8	d1000001-0000-4000-8000-0000000000b8	bc_bulk_184_4	8082	api	2025-08-25 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002bc	d1000001-0000-4000-8000-0000000000b9	bc_bulk_185_4	8099	pos	2025-08-20 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c0	d1000001-0000-4000-8000-0000000000ba	bc_bulk_186_4	8116	web	2025-08-15 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c4	d1000001-0000-4000-8000-0000000000bb	bc_bulk_187_4	8133	mobile	2025-08-10 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002c8	d1000001-0000-4000-8000-0000000000bc	bc_bulk_188_4	8150	api	2025-08-05 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002cc	d1000001-0000-4000-8000-0000000000bd	bc_bulk_189_4	8167	pos	2025-07-31 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d0	d1000001-0000-4000-8000-0000000000be	bc_bulk_190_4	8184	web	2025-07-26 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d4	d1000001-0000-4000-8000-0000000000bf	bc_bulk_191_4	8201	mobile	2025-07-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002d8	d1000001-0000-4000-8000-0000000000c0	bc_bulk_192_4	8218	api	2025-07-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002dc	d1000001-0000-4000-8000-0000000000c1	bc_bulk_193_4	8235	pos	2025-07-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e0	d1000001-0000-4000-8000-0000000000c2	bc_bulk_194_4	8252	web	2025-07-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e4	d1000001-0000-4000-8000-0000000000c3	bc_bulk_195_4	8269	mobile	2025-07-01 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002e8	d1000001-0000-4000-8000-0000000000c4	bc_bulk_196_4	8286	api	2025-06-26 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002ec	d1000001-0000-4000-8000-0000000000c5	bc_bulk_197_4	8303	pos	2025-06-21 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f0	d1000001-0000-4000-8000-0000000000c6	bc_bulk_198_4	8320	web	2025-06-16 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f4	d1000001-0000-4000-8000-0000000000c7	bc_bulk_199_4	8337	mobile	2025-06-11 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002f8	d1000001-0000-4000-8000-0000000000c8	bc_bulk_200_4	8354	api	2025-06-06 11:38:31.520924+00
d3000005-0000-4000-8000-0000000002fc	d1000001-0000-4000-8000-0000000000c9	bc_bulk_201_4	8371	pos	2025-06-01 11:38:31.520924+00
d3000005-0000-4000-8000-000000000300	d1000001-0000-4000-8000-0000000000ca	bc_bulk_202_4	8388	web	2025-05-27 11:38:31.520924+00
d3000005-0000-4000-8000-000000000304	d1000001-0000-4000-8000-0000000000cb	bc_bulk_203_4	8405	mobile	2025-05-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000308	d1000001-0000-4000-8000-0000000000cc	bc_bulk_204_4	8422	api	2025-05-17 11:38:31.520924+00
d3000005-0000-4000-8000-00000000030c	d1000001-0000-4000-8000-0000000000cd	bc_bulk_205_4	8439	pos	2025-05-12 11:38:31.520924+00
d3000005-0000-4000-8000-000000000310	d1000001-0000-4000-8000-0000000000ce	bc_bulk_206_4	8456	web	2025-05-07 11:38:31.520924+00
d3000005-0000-4000-8000-000000000314	d1000001-0000-4000-8000-0000000000cf	bc_bulk_207_4	8473	mobile	2025-05-02 11:38:31.520924+00
d3000005-0000-4000-8000-000000000318	d1000001-0000-4000-8000-0000000000d0	bc_bulk_208_4	8490	api	2025-04-27 11:38:31.520924+00
d3000005-0000-4000-8000-00000000031c	d1000001-0000-4000-8000-0000000000d1	bc_bulk_209_4	8507	pos	2025-04-22 11:38:31.520924+00
d3000005-0000-4000-8000-000000000320	d1000001-0000-4000-8000-0000000000d2	bc_bulk_210_4	8524	web	2025-04-17 11:38:31.520924+00
\.


--
-- Data for Name: certification_records; Type: TABLE DATA; Schema: demo; Owner: apiary
--

COPY demo.certification_records (id, person_id, certification_code, certification_name, training_method, passed_at, score_pct, created_at) FROM stdin;
78c7501f-3b4f-43f8-9fb5-9a9ea7461c61	d1000001-0000-4000-8000-000000000001	SAFE-OPS	Safe Operations	online	2026-01-25 11:38:31.412597+00	92	2026-02-25 11:38:31.412597+00
5344143d-aa45-41a4-9c2a-33a0c942d2de	d1000001-0000-4000-8000-000000000002	SAFE-OPS	Safe Operations	in_person	2025-12-25 11:38:31.412597+00	88	2026-02-25 11:38:31.412597+00
5e4e922b-dbe8-4705-8f7d-b38d978d7b59	d1000001-0000-4000-8000-000000000003	LIFT-101	Lift 101	online	2026-02-15 11:38:31.412597+00	95	2026-02-25 11:38:31.412597+00
0f654465-5636-4f1a-9193-43ebc7655628	d1000001-0000-4000-8000-000000000001	LIFT-101	Lift 101	hybrid	2025-11-25 11:38:31.412597+00	78	2026-02-25 11:38:31.412597+00
3bffbdb1-477e-4a4a-8bca-26512ce3e8b2	d1000001-0000-4000-8000-000000000004	SAFE-OPS	Safe Operations	in_person	2026-01-25 11:38:31.412597+00	81	2026-02-25 11:38:31.412597+00
2badcf7a-668f-4946-bbb7-b048e8b9f780	d1000001-0000-4000-8000-000000000005	SAFE-OPS	Safe Operations	online	2025-12-25 11:38:31.412597+00	90	2026-02-25 11:38:31.412597+00
d3000001-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000000b	FORK-201	Forklift 201	hybrid	2026-01-24 11:38:31.466569+00	74	2026-01-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000000c	REACH-101	Reach 101	online	2026-01-22 11:38:31.466569+00	77	2026-01-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000003	d1000001-0000-4000-8000-00000000000d	SAFE-OPS	Safe Operations	in_person	2026-01-20 11:38:31.466569+00	80	2026-01-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000004	d1000001-0000-4000-8000-00000000000e	LIFT-101	Lift 101	hybrid	2026-01-18 11:38:31.466569+00	83	2026-01-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000005	d1000001-0000-4000-8000-00000000000f	FORK-201	Forklift 201	online	2026-01-16 11:38:31.466569+00	86	2026-01-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000006	d1000001-0000-4000-8000-000000000010	REACH-101	Reach 101	in_person	2026-01-14 11:38:31.466569+00	89	2026-01-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000007	d1000001-0000-4000-8000-000000000011	SAFE-OPS	Safe Operations	hybrid	2026-01-12 11:38:31.466569+00	92	2026-01-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000008	d1000001-0000-4000-8000-000000000012	LIFT-101	Lift 101	online	2026-01-10 11:38:31.466569+00	95	2026-01-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000009	d1000001-0000-4000-8000-000000000013	FORK-201	Forklift 201	in_person	2026-01-08 11:38:31.466569+00	70	2026-01-08 11:38:31.466569+00
d3000001-0000-4000-8000-00000000000a	d1000001-0000-4000-8000-000000000014	REACH-101	Reach 101	hybrid	2026-01-06 11:38:31.466569+00	73	2026-01-06 11:38:31.466569+00
d3000001-0000-4000-8000-00000000000b	d1000001-0000-4000-8000-000000000015	SAFE-OPS	Safe Operations	online	2026-01-04 11:38:31.466569+00	76	2026-01-04 11:38:31.466569+00
d3000001-0000-4000-8000-00000000000c	d1000001-0000-4000-8000-000000000016	LIFT-101	Lift 101	in_person	2026-01-02 11:38:31.466569+00	79	2026-01-02 11:38:31.466569+00
d3000001-0000-4000-8000-00000000000d	d1000001-0000-4000-8000-000000000017	FORK-201	Forklift 201	hybrid	2025-12-31 11:38:31.466569+00	82	2025-12-31 11:38:31.466569+00
d3000001-0000-4000-8000-00000000000e	d1000001-0000-4000-8000-000000000018	REACH-101	Reach 101	online	2025-12-29 11:38:31.466569+00	85	2025-12-29 11:38:31.466569+00
d3000001-0000-4000-8000-00000000000f	d1000001-0000-4000-8000-000000000019	SAFE-OPS	Safe Operations	in_person	2025-12-27 11:38:31.466569+00	88	2025-12-27 11:38:31.466569+00
d3000001-0000-4000-8000-000000000010	d1000001-0000-4000-8000-00000000001a	LIFT-101	Lift 101	hybrid	2025-12-25 11:38:31.466569+00	91	2025-12-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000011	d1000001-0000-4000-8000-00000000001b	FORK-201	Forklift 201	online	2025-12-23 11:38:31.466569+00	94	2025-12-23 11:38:31.466569+00
d3000001-0000-4000-8000-000000000012	d1000001-0000-4000-8000-00000000001c	REACH-101	Reach 101	in_person	2025-12-21 11:38:31.466569+00	97	2025-12-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000013	d1000001-0000-4000-8000-00000000001d	SAFE-OPS	Safe Operations	hybrid	2025-12-19 11:38:31.466569+00	72	2025-12-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000014	d1000001-0000-4000-8000-00000000001e	LIFT-101	Lift 101	online	2025-12-17 11:38:31.466569+00	75	2025-12-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000015	d1000001-0000-4000-8000-00000000001f	FORK-201	Forklift 201	in_person	2025-12-15 11:38:31.466569+00	78	2025-12-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000016	d1000001-0000-4000-8000-000000000020	REACH-101	Reach 101	hybrid	2025-12-13 11:38:31.466569+00	81	2025-12-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000017	d1000001-0000-4000-8000-000000000021	SAFE-OPS	Safe Operations	online	2025-12-11 11:38:31.466569+00	84	2025-12-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000018	d1000001-0000-4000-8000-000000000022	LIFT-101	Lift 101	in_person	2025-12-09 11:38:31.466569+00	87	2025-12-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000019	d1000001-0000-4000-8000-000000000023	FORK-201	Forklift 201	hybrid	2025-12-07 11:38:31.466569+00	90	2025-12-07 11:38:31.466569+00
d3000001-0000-4000-8000-00000000001a	d1000001-0000-4000-8000-000000000024	REACH-101	Reach 101	online	2025-12-05 11:38:31.466569+00	93	2025-12-05 11:38:31.466569+00
d3000001-0000-4000-8000-00000000001b	d1000001-0000-4000-8000-000000000025	SAFE-OPS	Safe Operations	in_person	2025-12-03 11:38:31.466569+00	96	2025-12-03 11:38:31.466569+00
d3000001-0000-4000-8000-00000000001c	d1000001-0000-4000-8000-000000000026	LIFT-101	Lift 101	hybrid	2025-12-01 11:38:31.466569+00	71	2025-12-01 11:38:31.466569+00
d3000001-0000-4000-8000-00000000001d	d1000001-0000-4000-8000-000000000027	FORK-201	Forklift 201	online	2025-11-29 11:38:31.466569+00	74	2025-11-29 11:38:31.466569+00
d3000001-0000-4000-8000-00000000001e	d1000001-0000-4000-8000-000000000028	REACH-101	Reach 101	in_person	2025-11-27 11:38:31.466569+00	77	2025-11-27 11:38:31.466569+00
d3000001-0000-4000-8000-00000000001f	d1000001-0000-4000-8000-000000000029	SAFE-OPS	Safe Operations	hybrid	2025-11-25 11:38:31.466569+00	80	2025-11-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000020	d1000001-0000-4000-8000-00000000002a	LIFT-101	Lift 101	online	2025-11-23 11:38:31.466569+00	83	2025-11-23 11:38:31.466569+00
d3000001-0000-4000-8000-000000000021	d1000001-0000-4000-8000-00000000002b	FORK-201	Forklift 201	in_person	2025-11-21 11:38:31.466569+00	86	2025-11-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000022	d1000001-0000-4000-8000-00000000002c	REACH-101	Reach 101	hybrid	2025-11-19 11:38:31.466569+00	89	2025-11-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000023	d1000001-0000-4000-8000-00000000002d	SAFE-OPS	Safe Operations	online	2025-11-17 11:38:31.466569+00	92	2025-11-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000024	d1000001-0000-4000-8000-00000000002e	LIFT-101	Lift 101	in_person	2025-11-15 11:38:31.466569+00	95	2025-11-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000025	d1000001-0000-4000-8000-00000000002f	FORK-201	Forklift 201	hybrid	2025-11-13 11:38:31.466569+00	70	2025-11-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000026	d1000001-0000-4000-8000-000000000030	REACH-101	Reach 101	online	2025-11-11 11:38:31.466569+00	73	2025-11-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000027	d1000001-0000-4000-8000-000000000031	SAFE-OPS	Safe Operations	in_person	2025-11-09 11:38:31.466569+00	76	2025-11-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000028	d1000001-0000-4000-8000-000000000032	LIFT-101	Lift 101	hybrid	2025-11-07 11:38:31.466569+00	79	2025-11-07 11:38:31.466569+00
d3000001-0000-4000-8000-000000000029	d1000001-0000-4000-8000-000000000033	FORK-201	Forklift 201	online	2025-11-05 11:38:31.466569+00	82	2025-11-05 11:38:31.466569+00
d3000001-0000-4000-8000-00000000002a	d1000001-0000-4000-8000-000000000034	REACH-101	Reach 101	in_person	2025-11-03 11:38:31.466569+00	85	2025-11-03 11:38:31.466569+00
d3000001-0000-4000-8000-00000000002b	d1000001-0000-4000-8000-000000000035	SAFE-OPS	Safe Operations	hybrid	2025-11-01 11:38:31.466569+00	88	2025-11-01 11:38:31.466569+00
d3000001-0000-4000-8000-00000000002c	d1000001-0000-4000-8000-000000000036	LIFT-101	Lift 101	online	2025-10-30 11:38:31.466569+00	91	2025-10-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000002d	d1000001-0000-4000-8000-000000000037	FORK-201	Forklift 201	in_person	2025-10-28 11:38:31.466569+00	94	2025-10-28 11:38:31.466569+00
d3000001-0000-4000-8000-00000000002e	d1000001-0000-4000-8000-000000000038	REACH-101	Reach 101	hybrid	2025-10-26 11:38:31.466569+00	97	2025-10-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000002f	d1000001-0000-4000-8000-000000000039	SAFE-OPS	Safe Operations	online	2025-10-24 11:38:31.466569+00	72	2025-10-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000030	d1000001-0000-4000-8000-00000000003a	LIFT-101	Lift 101	in_person	2025-10-22 11:38:31.466569+00	75	2025-10-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000031	d1000001-0000-4000-8000-00000000003b	FORK-201	Forklift 201	hybrid	2025-10-20 11:38:31.466569+00	78	2025-10-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000032	d1000001-0000-4000-8000-00000000003c	REACH-101	Reach 101	online	2025-10-18 11:38:31.466569+00	81	2025-10-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000033	d1000001-0000-4000-8000-00000000003d	SAFE-OPS	Safe Operations	in_person	2025-10-16 11:38:31.466569+00	84	2025-10-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000034	d1000001-0000-4000-8000-00000000003e	LIFT-101	Lift 101	hybrid	2025-10-14 11:38:31.466569+00	87	2025-10-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000035	d1000001-0000-4000-8000-00000000003f	FORK-201	Forklift 201	online	2025-10-12 11:38:31.466569+00	90	2025-10-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000036	d1000001-0000-4000-8000-000000000040	REACH-101	Reach 101	in_person	2025-10-10 11:38:31.466569+00	93	2025-10-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000037	d1000001-0000-4000-8000-000000000041	SAFE-OPS	Safe Operations	hybrid	2025-10-08 11:38:31.466569+00	96	2025-10-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000038	d1000001-0000-4000-8000-000000000042	LIFT-101	Lift 101	online	2025-10-06 11:38:31.466569+00	71	2025-10-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000039	d1000001-0000-4000-8000-000000000043	FORK-201	Forklift 201	in_person	2025-10-04 11:38:31.466569+00	74	2025-10-04 11:38:31.466569+00
d3000001-0000-4000-8000-00000000003a	d1000001-0000-4000-8000-000000000044	REACH-101	Reach 101	hybrid	2025-10-02 11:38:31.466569+00	77	2025-10-02 11:38:31.466569+00
d3000001-0000-4000-8000-00000000003b	d1000001-0000-4000-8000-000000000045	SAFE-OPS	Safe Operations	online	2025-09-30 11:38:31.466569+00	80	2025-09-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000003c	d1000001-0000-4000-8000-000000000046	LIFT-101	Lift 101	in_person	2025-09-28 11:38:31.466569+00	83	2025-09-28 11:38:31.466569+00
d3000001-0000-4000-8000-00000000003d	d1000001-0000-4000-8000-000000000047	FORK-201	Forklift 201	hybrid	2025-09-26 11:38:31.466569+00	86	2025-09-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000003e	d1000001-0000-4000-8000-000000000048	REACH-101	Reach 101	online	2025-09-24 11:38:31.466569+00	89	2025-09-24 11:38:31.466569+00
d3000001-0000-4000-8000-00000000003f	d1000001-0000-4000-8000-000000000049	SAFE-OPS	Safe Operations	in_person	2025-09-22 11:38:31.466569+00	92	2025-09-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000040	d1000001-0000-4000-8000-00000000004a	LIFT-101	Lift 101	hybrid	2025-09-20 11:38:31.466569+00	95	2025-09-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000041	d1000001-0000-4000-8000-00000000004b	FORK-201	Forklift 201	online	2025-09-18 11:38:31.466569+00	70	2025-09-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000042	d1000001-0000-4000-8000-00000000004c	REACH-101	Reach 101	in_person	2025-09-16 11:38:31.466569+00	73	2025-09-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000043	d1000001-0000-4000-8000-00000000004d	SAFE-OPS	Safe Operations	hybrid	2025-09-14 11:38:31.466569+00	76	2025-09-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000044	d1000001-0000-4000-8000-00000000004e	LIFT-101	Lift 101	online	2025-09-12 11:38:31.466569+00	79	2025-09-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000045	d1000001-0000-4000-8000-00000000004f	FORK-201	Forklift 201	in_person	2025-09-10 11:38:31.466569+00	82	2025-09-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000046	d1000001-0000-4000-8000-000000000050	REACH-101	Reach 101	hybrid	2025-09-08 11:38:31.466569+00	85	2025-09-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000047	d1000001-0000-4000-8000-000000000051	SAFE-OPS	Safe Operations	online	2025-09-06 11:38:31.466569+00	88	2025-09-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000048	d1000001-0000-4000-8000-000000000052	LIFT-101	Lift 101	in_person	2025-09-04 11:38:31.466569+00	91	2025-09-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000049	d1000001-0000-4000-8000-000000000053	FORK-201	Forklift 201	hybrid	2025-09-02 11:38:31.466569+00	94	2025-09-02 11:38:31.466569+00
d3000001-0000-4000-8000-00000000004a	d1000001-0000-4000-8000-000000000054	REACH-101	Reach 101	online	2025-08-31 11:38:31.466569+00	97	2025-08-31 11:38:31.466569+00
d3000001-0000-4000-8000-00000000004b	d1000001-0000-4000-8000-000000000055	SAFE-OPS	Safe Operations	in_person	2025-08-29 11:38:31.466569+00	72	2025-08-29 11:38:31.466569+00
d3000001-0000-4000-8000-00000000004c	d1000001-0000-4000-8000-000000000056	LIFT-101	Lift 101	hybrid	2025-08-27 11:38:31.466569+00	75	2025-08-27 11:38:31.466569+00
d3000001-0000-4000-8000-00000000004d	d1000001-0000-4000-8000-000000000057	FORK-201	Forklift 201	online	2025-08-25 11:38:31.466569+00	78	2025-08-25 11:38:31.466569+00
d3000001-0000-4000-8000-00000000004e	d1000001-0000-4000-8000-000000000058	REACH-101	Reach 101	in_person	2025-08-23 11:38:31.466569+00	81	2025-08-23 11:38:31.466569+00
d3000001-0000-4000-8000-00000000004f	d1000001-0000-4000-8000-000000000059	SAFE-OPS	Safe Operations	hybrid	2025-08-21 11:38:31.466569+00	84	2025-08-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000050	d1000001-0000-4000-8000-00000000005a	LIFT-101	Lift 101	online	2025-08-19 11:38:31.466569+00	87	2025-08-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000051	d1000001-0000-4000-8000-00000000005b	FORK-201	Forklift 201	in_person	2025-08-17 11:38:31.466569+00	90	2025-08-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000052	d1000001-0000-4000-8000-00000000005c	REACH-101	Reach 101	hybrid	2025-08-15 11:38:31.466569+00	93	2025-08-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000053	d1000001-0000-4000-8000-00000000005d	SAFE-OPS	Safe Operations	online	2025-08-13 11:38:31.466569+00	96	2025-08-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000054	d1000001-0000-4000-8000-00000000005e	LIFT-101	Lift 101	in_person	2025-08-11 11:38:31.466569+00	71	2025-08-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000055	d1000001-0000-4000-8000-00000000005f	FORK-201	Forklift 201	hybrid	2025-08-09 11:38:31.466569+00	74	2025-08-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000056	d1000001-0000-4000-8000-000000000060	REACH-101	Reach 101	online	2025-08-07 11:38:31.466569+00	77	2025-08-07 11:38:31.466569+00
d3000001-0000-4000-8000-000000000057	d1000001-0000-4000-8000-000000000061	SAFE-OPS	Safe Operations	in_person	2025-08-05 11:38:31.466569+00	80	2025-08-05 11:38:31.466569+00
d3000001-0000-4000-8000-000000000058	d1000001-0000-4000-8000-000000000062	LIFT-101	Lift 101	hybrid	2025-08-03 11:38:31.466569+00	83	2025-08-03 11:38:31.466569+00
d3000001-0000-4000-8000-000000000059	d1000001-0000-4000-8000-000000000063	FORK-201	Forklift 201	online	2025-08-01 11:38:31.466569+00	86	2025-08-01 11:38:31.466569+00
d3000001-0000-4000-8000-00000000005a	d1000001-0000-4000-8000-000000000064	REACH-101	Reach 101	in_person	2025-07-30 11:38:31.466569+00	89	2025-07-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000005b	d1000001-0000-4000-8000-000000000065	SAFE-OPS	Safe Operations	hybrid	2025-07-28 11:38:31.466569+00	92	2025-07-28 11:38:31.466569+00
d3000001-0000-4000-8000-00000000005c	d1000001-0000-4000-8000-000000000066	LIFT-101	Lift 101	online	2025-07-26 11:38:31.466569+00	95	2025-07-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000005d	d1000001-0000-4000-8000-000000000067	FORK-201	Forklift 201	in_person	2025-07-24 11:38:31.466569+00	70	2025-07-24 11:38:31.466569+00
d3000001-0000-4000-8000-00000000005e	d1000001-0000-4000-8000-000000000068	REACH-101	Reach 101	hybrid	2025-07-22 11:38:31.466569+00	73	2025-07-22 11:38:31.466569+00
d3000001-0000-4000-8000-00000000005f	d1000001-0000-4000-8000-000000000069	SAFE-OPS	Safe Operations	online	2025-07-20 11:38:31.466569+00	76	2025-07-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000060	d1000001-0000-4000-8000-00000000006a	LIFT-101	Lift 101	in_person	2025-07-18 11:38:31.466569+00	79	2025-07-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000061	d1000001-0000-4000-8000-00000000006b	FORK-201	Forklift 201	hybrid	2025-07-16 11:38:31.466569+00	82	2025-07-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000062	d1000001-0000-4000-8000-00000000006c	REACH-101	Reach 101	online	2025-07-14 11:38:31.466569+00	85	2025-07-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000063	d1000001-0000-4000-8000-00000000006d	SAFE-OPS	Safe Operations	in_person	2025-07-12 11:38:31.466569+00	88	2025-07-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000064	d1000001-0000-4000-8000-00000000006e	LIFT-101	Lift 101	hybrid	2025-07-10 11:38:31.466569+00	91	2025-07-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000065	d1000001-0000-4000-8000-00000000006f	FORK-201	Forklift 201	online	2025-07-08 11:38:31.466569+00	94	2025-07-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000066	d1000001-0000-4000-8000-000000000070	REACH-101	Reach 101	in_person	2025-07-06 11:38:31.466569+00	97	2025-07-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000067	d1000001-0000-4000-8000-000000000071	SAFE-OPS	Safe Operations	hybrid	2025-07-04 11:38:31.466569+00	72	2025-07-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000068	d1000001-0000-4000-8000-000000000072	LIFT-101	Lift 101	online	2025-07-02 11:38:31.466569+00	75	2025-07-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000069	d1000001-0000-4000-8000-000000000073	FORK-201	Forklift 201	in_person	2025-06-30 11:38:31.466569+00	78	2025-06-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000006a	d1000001-0000-4000-8000-000000000074	REACH-101	Reach 101	hybrid	2025-06-28 11:38:31.466569+00	81	2025-06-28 11:38:31.466569+00
d3000001-0000-4000-8000-00000000006b	d1000001-0000-4000-8000-000000000075	SAFE-OPS	Safe Operations	online	2025-06-26 11:38:31.466569+00	84	2025-06-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000006c	d1000001-0000-4000-8000-000000000076	LIFT-101	Lift 101	in_person	2025-06-24 11:38:31.466569+00	87	2025-06-24 11:38:31.466569+00
d3000001-0000-4000-8000-00000000006d	d1000001-0000-4000-8000-000000000077	FORK-201	Forklift 201	hybrid	2025-06-22 11:38:31.466569+00	90	2025-06-22 11:38:31.466569+00
d3000001-0000-4000-8000-00000000006e	d1000001-0000-4000-8000-000000000078	REACH-101	Reach 101	online	2025-06-20 11:38:31.466569+00	93	2025-06-20 11:38:31.466569+00
d3000001-0000-4000-8000-00000000006f	d1000001-0000-4000-8000-000000000079	SAFE-OPS	Safe Operations	in_person	2025-06-18 11:38:31.466569+00	96	2025-06-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000070	d1000001-0000-4000-8000-00000000007a	LIFT-101	Lift 101	hybrid	2025-06-16 11:38:31.466569+00	71	2025-06-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000071	d1000001-0000-4000-8000-00000000007b	FORK-201	Forklift 201	online	2025-06-14 11:38:31.466569+00	74	2025-06-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000072	d1000001-0000-4000-8000-00000000007c	REACH-101	Reach 101	in_person	2025-06-12 11:38:31.466569+00	77	2025-06-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000073	d1000001-0000-4000-8000-00000000007d	SAFE-OPS	Safe Operations	hybrid	2025-06-10 11:38:31.466569+00	80	2025-06-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000074	d1000001-0000-4000-8000-00000000007e	LIFT-101	Lift 101	online	2025-06-08 11:38:31.466569+00	83	2025-06-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000075	d1000001-0000-4000-8000-00000000007f	FORK-201	Forklift 201	in_person	2025-06-06 11:38:31.466569+00	86	2025-06-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000076	d1000001-0000-4000-8000-000000000080	REACH-101	Reach 101	hybrid	2025-06-04 11:38:31.466569+00	89	2025-06-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000077	d1000001-0000-4000-8000-000000000081	SAFE-OPS	Safe Operations	online	2025-06-02 11:38:31.466569+00	92	2025-06-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000078	d1000001-0000-4000-8000-000000000082	LIFT-101	Lift 101	in_person	2025-05-31 11:38:31.466569+00	95	2025-05-31 11:38:31.466569+00
d3000001-0000-4000-8000-000000000079	d1000001-0000-4000-8000-000000000083	FORK-201	Forklift 201	hybrid	2025-05-29 11:38:31.466569+00	70	2025-05-29 11:38:31.466569+00
d3000001-0000-4000-8000-00000000007a	d1000001-0000-4000-8000-000000000084	REACH-101	Reach 101	online	2025-05-27 11:38:31.466569+00	73	2025-05-27 11:38:31.466569+00
d3000001-0000-4000-8000-00000000007b	d1000001-0000-4000-8000-000000000085	SAFE-OPS	Safe Operations	in_person	2025-05-25 11:38:31.466569+00	76	2025-05-25 11:38:31.466569+00
d3000001-0000-4000-8000-00000000007c	d1000001-0000-4000-8000-000000000086	LIFT-101	Lift 101	hybrid	2025-05-23 11:38:31.466569+00	79	2025-05-23 11:38:31.466569+00
d3000001-0000-4000-8000-00000000007d	d1000001-0000-4000-8000-000000000087	FORK-201	Forklift 201	online	2025-05-21 11:38:31.466569+00	82	2025-05-21 11:38:31.466569+00
d3000001-0000-4000-8000-00000000007e	d1000001-0000-4000-8000-000000000088	REACH-101	Reach 101	in_person	2025-05-19 11:38:31.466569+00	85	2025-05-19 11:38:31.466569+00
d3000001-0000-4000-8000-00000000007f	d1000001-0000-4000-8000-000000000089	SAFE-OPS	Safe Operations	hybrid	2025-05-17 11:38:31.466569+00	88	2025-05-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000080	d1000001-0000-4000-8000-00000000008a	LIFT-101	Lift 101	online	2025-05-15 11:38:31.466569+00	91	2025-05-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000081	d1000001-0000-4000-8000-00000000008b	FORK-201	Forklift 201	in_person	2025-05-13 11:38:31.466569+00	94	2025-05-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000082	d1000001-0000-4000-8000-00000000008c	REACH-101	Reach 101	hybrid	2025-05-11 11:38:31.466569+00	97	2025-05-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000083	d1000001-0000-4000-8000-00000000008d	SAFE-OPS	Safe Operations	online	2025-05-09 11:38:31.466569+00	72	2025-05-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000084	d1000001-0000-4000-8000-00000000008e	LIFT-101	Lift 101	in_person	2025-05-07 11:38:31.466569+00	75	2025-05-07 11:38:31.466569+00
d3000001-0000-4000-8000-000000000085	d1000001-0000-4000-8000-00000000008f	FORK-201	Forklift 201	hybrid	2025-05-05 11:38:31.466569+00	78	2025-05-05 11:38:31.466569+00
d3000001-0000-4000-8000-000000000086	d1000001-0000-4000-8000-000000000090	REACH-101	Reach 101	online	2025-05-03 11:38:31.466569+00	81	2025-05-03 11:38:31.466569+00
d3000001-0000-4000-8000-000000000087	d1000001-0000-4000-8000-000000000091	SAFE-OPS	Safe Operations	in_person	2025-05-01 11:38:31.466569+00	84	2025-05-01 11:38:31.466569+00
d3000001-0000-4000-8000-000000000088	d1000001-0000-4000-8000-000000000092	LIFT-101	Lift 101	hybrid	2025-04-29 11:38:31.466569+00	87	2025-04-29 11:38:31.466569+00
d3000001-0000-4000-8000-000000000089	d1000001-0000-4000-8000-000000000093	FORK-201	Forklift 201	online	2025-04-27 11:38:31.466569+00	90	2025-04-27 11:38:31.466569+00
d3000001-0000-4000-8000-00000000008a	d1000001-0000-4000-8000-000000000094	REACH-101	Reach 101	in_person	2025-04-25 11:38:31.466569+00	93	2025-04-25 11:38:31.466569+00
d3000001-0000-4000-8000-00000000008b	d1000001-0000-4000-8000-000000000095	SAFE-OPS	Safe Operations	hybrid	2025-04-23 11:38:31.466569+00	96	2025-04-23 11:38:31.466569+00
d3000001-0000-4000-8000-00000000008c	d1000001-0000-4000-8000-000000000096	LIFT-101	Lift 101	online	2025-04-21 11:38:31.466569+00	71	2025-04-21 11:38:31.466569+00
d3000001-0000-4000-8000-00000000008d	d1000001-0000-4000-8000-000000000097	FORK-201	Forklift 201	in_person	2025-04-19 11:38:31.466569+00	74	2025-04-19 11:38:31.466569+00
d3000001-0000-4000-8000-00000000008e	d1000001-0000-4000-8000-000000000098	REACH-101	Reach 101	hybrid	2025-04-17 11:38:31.466569+00	77	2025-04-17 11:38:31.466569+00
d3000001-0000-4000-8000-00000000008f	d1000001-0000-4000-8000-000000000099	SAFE-OPS	Safe Operations	online	2025-04-15 11:38:31.466569+00	80	2025-04-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000090	d1000001-0000-4000-8000-00000000009a	LIFT-101	Lift 101	in_person	2025-04-13 11:38:31.466569+00	83	2025-04-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000091	d1000001-0000-4000-8000-00000000009b	FORK-201	Forklift 201	hybrid	2025-04-11 11:38:31.466569+00	86	2025-04-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000092	d1000001-0000-4000-8000-00000000009c	REACH-101	Reach 101	online	2025-04-09 11:38:31.466569+00	89	2025-04-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000093	d1000001-0000-4000-8000-00000000009d	SAFE-OPS	Safe Operations	in_person	2025-04-07 11:38:31.466569+00	92	2025-04-07 11:38:31.466569+00
d3000001-0000-4000-8000-000000000094	d1000001-0000-4000-8000-00000000009e	LIFT-101	Lift 101	hybrid	2025-04-05 11:38:31.466569+00	95	2025-04-05 11:38:31.466569+00
d3000001-0000-4000-8000-000000000095	d1000001-0000-4000-8000-00000000009f	FORK-201	Forklift 201	online	2025-04-03 11:38:31.466569+00	70	2025-04-03 11:38:31.466569+00
d3000001-0000-4000-8000-000000000096	d1000001-0000-4000-8000-0000000000a0	REACH-101	Reach 101	in_person	2025-04-01 11:38:31.466569+00	73	2025-04-01 11:38:31.466569+00
d3000001-0000-4000-8000-000000000097	d1000001-0000-4000-8000-0000000000a1	SAFE-OPS	Safe Operations	hybrid	2025-03-30 11:38:31.466569+00	76	2025-03-30 11:38:31.466569+00
d3000001-0000-4000-8000-000000000098	d1000001-0000-4000-8000-0000000000a2	LIFT-101	Lift 101	online	2025-03-28 11:38:31.466569+00	79	2025-03-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000099	d1000001-0000-4000-8000-0000000000a3	FORK-201	Forklift 201	in_person	2025-03-26 11:38:31.466569+00	82	2025-03-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000009a	d1000001-0000-4000-8000-0000000000a4	REACH-101	Reach 101	hybrid	2025-03-24 11:38:31.466569+00	85	2025-03-24 11:38:31.466569+00
d3000001-0000-4000-8000-00000000009b	d1000001-0000-4000-8000-0000000000a5	SAFE-OPS	Safe Operations	online	2025-03-22 11:38:31.466569+00	88	2025-03-22 11:38:31.466569+00
d3000001-0000-4000-8000-00000000009c	d1000001-0000-4000-8000-0000000000a6	LIFT-101	Lift 101	in_person	2025-03-20 11:38:31.466569+00	91	2025-03-20 11:38:31.466569+00
d3000001-0000-4000-8000-00000000009d	d1000001-0000-4000-8000-0000000000a7	FORK-201	Forklift 201	hybrid	2025-03-18 11:38:31.466569+00	94	2025-03-18 11:38:31.466569+00
d3000001-0000-4000-8000-00000000009e	d1000001-0000-4000-8000-0000000000a8	REACH-101	Reach 101	online	2025-03-16 11:38:31.466569+00	97	2025-03-16 11:38:31.466569+00
d3000001-0000-4000-8000-00000000009f	d1000001-0000-4000-8000-0000000000a9	SAFE-OPS	Safe Operations	in_person	2025-03-14 11:38:31.466569+00	72	2025-03-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a0	d1000001-0000-4000-8000-0000000000aa	LIFT-101	Lift 101	hybrid	2025-03-12 11:38:31.466569+00	75	2025-03-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a1	d1000001-0000-4000-8000-0000000000ab	FORK-201	Forklift 201	online	2025-03-10 11:38:31.466569+00	78	2025-03-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a2	d1000001-0000-4000-8000-0000000000ac	REACH-101	Reach 101	in_person	2025-03-08 11:38:31.466569+00	81	2025-03-08 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a3	d1000001-0000-4000-8000-0000000000ad	SAFE-OPS	Safe Operations	hybrid	2025-03-06 11:38:31.466569+00	84	2025-03-06 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a4	d1000001-0000-4000-8000-0000000000ae	LIFT-101	Lift 101	online	2025-03-04 11:38:31.466569+00	87	2025-03-04 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a5	d1000001-0000-4000-8000-0000000000af	FORK-201	Forklift 201	in_person	2025-03-02 11:38:31.466569+00	90	2025-03-02 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a6	d1000001-0000-4000-8000-0000000000b0	REACH-101	Reach 101	hybrid	2025-02-28 11:38:31.466569+00	93	2025-02-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a7	d1000001-0000-4000-8000-0000000000b1	SAFE-OPS	Safe Operations	online	2025-02-26 11:38:31.466569+00	96	2025-02-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a8	d1000001-0000-4000-8000-0000000000b2	LIFT-101	Lift 101	in_person	2026-02-24 11:38:31.466569+00	71	2026-02-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000a9	d1000001-0000-4000-8000-0000000000b3	FORK-201	Forklift 201	hybrid	2026-02-22 11:38:31.466569+00	74	2026-02-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000aa	d1000001-0000-4000-8000-0000000000b4	REACH-101	Reach 101	online	2026-02-20 11:38:31.466569+00	77	2026-02-20 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ab	d1000001-0000-4000-8000-0000000000b5	SAFE-OPS	Safe Operations	in_person	2026-02-18 11:38:31.466569+00	80	2026-02-18 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ac	d1000001-0000-4000-8000-0000000000b6	LIFT-101	Lift 101	hybrid	2026-02-16 11:38:31.466569+00	83	2026-02-16 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ad	d1000001-0000-4000-8000-0000000000b7	FORK-201	Forklift 201	online	2026-02-14 11:38:31.466569+00	86	2026-02-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ae	d1000001-0000-4000-8000-0000000000b8	REACH-101	Reach 101	in_person	2026-02-12 11:38:31.466569+00	89	2026-02-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000af	d1000001-0000-4000-8000-0000000000b9	SAFE-OPS	Safe Operations	hybrid	2026-02-10 11:38:31.466569+00	92	2026-02-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b0	d1000001-0000-4000-8000-0000000000ba	LIFT-101	Lift 101	online	2026-02-08 11:38:31.466569+00	95	2026-02-08 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b1	d1000001-0000-4000-8000-0000000000bb	FORK-201	Forklift 201	in_person	2026-02-06 11:38:31.466569+00	70	2026-02-06 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b2	d1000001-0000-4000-8000-0000000000bc	REACH-101	Reach 101	hybrid	2026-02-04 11:38:31.466569+00	73	2026-02-04 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b3	d1000001-0000-4000-8000-0000000000bd	SAFE-OPS	Safe Operations	online	2026-02-02 11:38:31.466569+00	76	2026-02-02 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b4	d1000001-0000-4000-8000-0000000000be	LIFT-101	Lift 101	in_person	2026-01-31 11:38:31.466569+00	79	2026-01-31 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b5	d1000001-0000-4000-8000-0000000000bf	FORK-201	Forklift 201	hybrid	2026-01-29 11:38:31.466569+00	82	2026-01-29 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b6	d1000001-0000-4000-8000-0000000000c0	REACH-101	Reach 101	online	2026-01-27 11:38:31.466569+00	85	2026-01-27 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b7	d1000001-0000-4000-8000-0000000000c1	SAFE-OPS	Safe Operations	in_person	2026-01-25 11:38:31.466569+00	88	2026-01-25 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b8	d1000001-0000-4000-8000-0000000000c2	LIFT-101	Lift 101	hybrid	2026-01-23 11:38:31.466569+00	91	2026-01-23 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000b9	d1000001-0000-4000-8000-0000000000c3	FORK-201	Forklift 201	online	2026-01-21 11:38:31.466569+00	94	2026-01-21 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ba	d1000001-0000-4000-8000-0000000000c4	REACH-101	Reach 101	in_person	2026-01-19 11:38:31.466569+00	97	2026-01-19 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000bb	d1000001-0000-4000-8000-0000000000c5	SAFE-OPS	Safe Operations	hybrid	2026-01-17 11:38:31.466569+00	72	2026-01-17 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000bc	d1000001-0000-4000-8000-0000000000c6	LIFT-101	Lift 101	online	2026-01-15 11:38:31.466569+00	75	2026-01-15 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000bd	d1000001-0000-4000-8000-0000000000c7	FORK-201	Forklift 201	in_person	2026-01-13 11:38:31.466569+00	78	2026-01-13 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000be	d1000001-0000-4000-8000-0000000000c8	REACH-101	Reach 101	hybrid	2026-01-11 11:38:31.466569+00	81	2026-01-11 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000bf	d1000001-0000-4000-8000-0000000000c9	SAFE-OPS	Safe Operations	online	2026-01-09 11:38:31.466569+00	84	2026-01-09 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c0	d1000001-0000-4000-8000-0000000000ca	LIFT-101	Lift 101	in_person	2026-01-07 11:38:31.466569+00	87	2026-01-07 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c1	d1000001-0000-4000-8000-0000000000cb	FORK-201	Forklift 201	hybrid	2026-01-05 11:38:31.466569+00	90	2026-01-05 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c2	d1000001-0000-4000-8000-0000000000cc	REACH-101	Reach 101	online	2026-01-03 11:38:31.466569+00	93	2026-01-03 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c3	d1000001-0000-4000-8000-0000000000cd	SAFE-OPS	Safe Operations	in_person	2026-01-01 11:38:31.466569+00	96	2026-01-01 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c4	d1000001-0000-4000-8000-0000000000ce	LIFT-101	Lift 101	hybrid	2025-12-30 11:38:31.466569+00	71	2025-12-30 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c5	d1000001-0000-4000-8000-0000000000cf	FORK-201	Forklift 201	online	2025-12-28 11:38:31.466569+00	74	2025-12-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c6	d1000001-0000-4000-8000-0000000000d0	REACH-101	Reach 101	in_person	2025-12-26 11:38:31.466569+00	77	2025-12-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c7	d1000001-0000-4000-8000-0000000000d1	SAFE-OPS	Safe Operations	hybrid	2025-12-24 11:38:31.466569+00	80	2025-12-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c8	d1000001-0000-4000-8000-0000000000d2	LIFT-101	Lift 101	online	2025-12-22 11:38:31.466569+00	83	2025-12-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000c9	d1000001-0000-4000-8000-00000000000b	REACH-101	Reach 101	online	2025-12-25 11:38:31.466569+00	75	2025-12-25 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ca	d1000001-0000-4000-8000-00000000000c	SAFE-OPS	Safe Operations	in_person	2025-12-23 11:38:31.466569+00	78	2025-12-23 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000cb	d1000001-0000-4000-8000-00000000000d	LIFT-101	Lift 101	hybrid	2025-12-21 11:38:31.466569+00	81	2025-12-21 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000cc	d1000001-0000-4000-8000-00000000000e	FORK-201	Forklift 201	online	2025-12-19 11:38:31.466569+00	84	2025-12-19 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000cd	d1000001-0000-4000-8000-00000000000f	REACH-101	Reach 101	in_person	2025-12-17 11:38:31.466569+00	87	2025-12-17 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ce	d1000001-0000-4000-8000-000000000010	SAFE-OPS	Safe Operations	hybrid	2025-12-15 11:38:31.466569+00	90	2025-12-15 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000cf	d1000001-0000-4000-8000-000000000011	LIFT-101	Lift 101	online	2025-12-13 11:38:31.466569+00	93	2025-12-13 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d0	d1000001-0000-4000-8000-000000000012	FORK-201	Forklift 201	in_person	2025-12-11 11:38:31.466569+00	96	2025-12-11 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d1	d1000001-0000-4000-8000-000000000013	REACH-101	Reach 101	hybrid	2025-12-09 11:38:31.466569+00	71	2025-12-09 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d2	d1000001-0000-4000-8000-000000000014	SAFE-OPS	Safe Operations	online	2025-12-07 11:38:31.466569+00	74	2025-12-07 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d3	d1000001-0000-4000-8000-000000000015	LIFT-101	Lift 101	in_person	2025-12-05 11:38:31.466569+00	77	2025-12-05 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d4	d1000001-0000-4000-8000-000000000016	FORK-201	Forklift 201	hybrid	2025-12-03 11:38:31.466569+00	80	2025-12-03 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d5	d1000001-0000-4000-8000-000000000017	REACH-101	Reach 101	online	2025-12-01 11:38:31.466569+00	83	2025-12-01 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d6	d1000001-0000-4000-8000-000000000018	SAFE-OPS	Safe Operations	in_person	2025-11-29 11:38:31.466569+00	86	2025-11-29 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d7	d1000001-0000-4000-8000-000000000019	LIFT-101	Lift 101	hybrid	2025-11-27 11:38:31.466569+00	89	2025-11-27 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d8	d1000001-0000-4000-8000-00000000001a	FORK-201	Forklift 201	online	2025-11-25 11:38:31.466569+00	92	2025-11-25 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000d9	d1000001-0000-4000-8000-00000000001b	REACH-101	Reach 101	in_person	2025-11-23 11:38:31.466569+00	95	2025-11-23 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000da	d1000001-0000-4000-8000-00000000001c	SAFE-OPS	Safe Operations	hybrid	2025-11-21 11:38:31.466569+00	70	2025-11-21 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000db	d1000001-0000-4000-8000-00000000001d	LIFT-101	Lift 101	online	2025-11-19 11:38:31.466569+00	73	2025-11-19 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000dc	d1000001-0000-4000-8000-00000000001e	FORK-201	Forklift 201	in_person	2025-11-17 11:38:31.466569+00	76	2025-11-17 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000dd	d1000001-0000-4000-8000-00000000001f	REACH-101	Reach 101	hybrid	2025-11-15 11:38:31.466569+00	79	2025-11-15 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000de	d1000001-0000-4000-8000-000000000020	SAFE-OPS	Safe Operations	online	2025-11-13 11:38:31.466569+00	82	2025-11-13 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000df	d1000001-0000-4000-8000-000000000021	LIFT-101	Lift 101	in_person	2025-11-11 11:38:31.466569+00	85	2025-11-11 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e0	d1000001-0000-4000-8000-000000000022	FORK-201	Forklift 201	hybrid	2025-11-09 11:38:31.466569+00	88	2025-11-09 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e1	d1000001-0000-4000-8000-000000000023	REACH-101	Reach 101	online	2025-11-07 11:38:31.466569+00	91	2025-11-07 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e2	d1000001-0000-4000-8000-000000000024	SAFE-OPS	Safe Operations	in_person	2025-11-05 11:38:31.466569+00	94	2025-11-05 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e3	d1000001-0000-4000-8000-000000000025	LIFT-101	Lift 101	hybrid	2025-11-03 11:38:31.466569+00	97	2025-11-03 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e4	d1000001-0000-4000-8000-000000000026	FORK-201	Forklift 201	online	2025-11-01 11:38:31.466569+00	72	2025-11-01 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e5	d1000001-0000-4000-8000-000000000027	REACH-101	Reach 101	in_person	2025-10-30 11:38:31.466569+00	75	2025-10-30 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e6	d1000001-0000-4000-8000-000000000028	SAFE-OPS	Safe Operations	hybrid	2025-10-28 11:38:31.466569+00	78	2025-10-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e7	d1000001-0000-4000-8000-000000000029	LIFT-101	Lift 101	online	2025-10-26 11:38:31.466569+00	81	2025-10-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e8	d1000001-0000-4000-8000-00000000002a	FORK-201	Forklift 201	in_person	2025-10-24 11:38:31.466569+00	84	2025-10-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000e9	d1000001-0000-4000-8000-00000000002b	REACH-101	Reach 101	hybrid	2025-10-22 11:38:31.466569+00	87	2025-10-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ea	d1000001-0000-4000-8000-00000000002c	SAFE-OPS	Safe Operations	online	2025-10-20 11:38:31.466569+00	90	2025-10-20 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000eb	d1000001-0000-4000-8000-00000000002d	LIFT-101	Lift 101	in_person	2025-10-18 11:38:31.466569+00	93	2025-10-18 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ec	d1000001-0000-4000-8000-00000000002e	FORK-201	Forklift 201	hybrid	2025-10-16 11:38:31.466569+00	96	2025-10-16 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ed	d1000001-0000-4000-8000-00000000002f	REACH-101	Reach 101	online	2025-10-14 11:38:31.466569+00	71	2025-10-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ee	d1000001-0000-4000-8000-000000000030	SAFE-OPS	Safe Operations	in_person	2025-10-12 11:38:31.466569+00	74	2025-10-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ef	d1000001-0000-4000-8000-000000000031	LIFT-101	Lift 101	hybrid	2025-10-10 11:38:31.466569+00	77	2025-10-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f0	d1000001-0000-4000-8000-000000000032	FORK-201	Forklift 201	online	2025-10-08 11:38:31.466569+00	80	2025-10-08 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f1	d1000001-0000-4000-8000-000000000033	REACH-101	Reach 101	in_person	2025-10-06 11:38:31.466569+00	83	2025-10-06 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f2	d1000001-0000-4000-8000-000000000034	SAFE-OPS	Safe Operations	hybrid	2025-10-04 11:38:31.466569+00	86	2025-10-04 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f3	d1000001-0000-4000-8000-000000000035	LIFT-101	Lift 101	online	2025-10-02 11:38:31.466569+00	89	2025-10-02 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f4	d1000001-0000-4000-8000-000000000036	FORK-201	Forklift 201	in_person	2025-09-30 11:38:31.466569+00	92	2025-09-30 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f5	d1000001-0000-4000-8000-000000000037	REACH-101	Reach 101	hybrid	2025-09-28 11:38:31.466569+00	95	2025-09-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f6	d1000001-0000-4000-8000-000000000038	SAFE-OPS	Safe Operations	online	2025-09-26 11:38:31.466569+00	70	2025-09-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f7	d1000001-0000-4000-8000-000000000039	LIFT-101	Lift 101	in_person	2025-09-24 11:38:31.466569+00	73	2025-09-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f8	d1000001-0000-4000-8000-00000000003a	FORK-201	Forklift 201	hybrid	2025-09-22 11:38:31.466569+00	76	2025-09-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000f9	d1000001-0000-4000-8000-00000000003b	REACH-101	Reach 101	online	2025-09-20 11:38:31.466569+00	79	2025-09-20 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000fa	d1000001-0000-4000-8000-00000000003c	SAFE-OPS	Safe Operations	in_person	2025-09-18 11:38:31.466569+00	82	2025-09-18 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000fb	d1000001-0000-4000-8000-00000000003d	LIFT-101	Lift 101	hybrid	2025-09-16 11:38:31.466569+00	85	2025-09-16 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000fc	d1000001-0000-4000-8000-00000000003e	FORK-201	Forklift 201	online	2025-09-14 11:38:31.466569+00	88	2025-09-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000fd	d1000001-0000-4000-8000-00000000003f	REACH-101	Reach 101	in_person	2025-09-12 11:38:31.466569+00	91	2025-09-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000fe	d1000001-0000-4000-8000-000000000040	SAFE-OPS	Safe Operations	hybrid	2025-09-10 11:38:31.466569+00	94	2025-09-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000000ff	d1000001-0000-4000-8000-000000000041	LIFT-101	Lift 101	online	2025-09-08 11:38:31.466569+00	97	2025-09-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000100	d1000001-0000-4000-8000-000000000042	FORK-201	Forklift 201	in_person	2025-09-06 11:38:31.466569+00	72	2025-09-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000101	d1000001-0000-4000-8000-000000000043	REACH-101	Reach 101	hybrid	2025-09-04 11:38:31.466569+00	75	2025-09-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000102	d1000001-0000-4000-8000-000000000044	SAFE-OPS	Safe Operations	online	2025-09-02 11:38:31.466569+00	78	2025-09-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000103	d1000001-0000-4000-8000-000000000045	LIFT-101	Lift 101	in_person	2025-08-31 11:38:31.466569+00	81	2025-08-31 11:38:31.466569+00
d3000001-0000-4000-8000-000000000104	d1000001-0000-4000-8000-000000000046	FORK-201	Forklift 201	hybrid	2025-08-29 11:38:31.466569+00	84	2025-08-29 11:38:31.466569+00
d3000001-0000-4000-8000-000000000105	d1000001-0000-4000-8000-000000000047	REACH-101	Reach 101	online	2025-08-27 11:38:31.466569+00	87	2025-08-27 11:38:31.466569+00
d3000001-0000-4000-8000-000000000106	d1000001-0000-4000-8000-000000000048	SAFE-OPS	Safe Operations	in_person	2025-08-25 11:38:31.466569+00	90	2025-08-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000107	d1000001-0000-4000-8000-000000000049	LIFT-101	Lift 101	hybrid	2025-08-23 11:38:31.466569+00	93	2025-08-23 11:38:31.466569+00
d3000001-0000-4000-8000-000000000108	d1000001-0000-4000-8000-00000000004a	FORK-201	Forklift 201	online	2025-08-21 11:38:31.466569+00	96	2025-08-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000109	d1000001-0000-4000-8000-00000000004b	REACH-101	Reach 101	in_person	2025-08-19 11:38:31.466569+00	71	2025-08-19 11:38:31.466569+00
d3000001-0000-4000-8000-00000000010a	d1000001-0000-4000-8000-00000000004c	SAFE-OPS	Safe Operations	hybrid	2025-08-17 11:38:31.466569+00	74	2025-08-17 11:38:31.466569+00
d3000001-0000-4000-8000-00000000010b	d1000001-0000-4000-8000-00000000004d	LIFT-101	Lift 101	online	2025-08-15 11:38:31.466569+00	77	2025-08-15 11:38:31.466569+00
d3000001-0000-4000-8000-00000000010c	d1000001-0000-4000-8000-00000000004e	FORK-201	Forklift 201	in_person	2025-08-13 11:38:31.466569+00	80	2025-08-13 11:38:31.466569+00
d3000001-0000-4000-8000-00000000010d	d1000001-0000-4000-8000-00000000004f	REACH-101	Reach 101	hybrid	2025-08-11 11:38:31.466569+00	83	2025-08-11 11:38:31.466569+00
d3000001-0000-4000-8000-00000000010e	d1000001-0000-4000-8000-000000000050	SAFE-OPS	Safe Operations	online	2025-08-09 11:38:31.466569+00	86	2025-08-09 11:38:31.466569+00
d3000001-0000-4000-8000-00000000010f	d1000001-0000-4000-8000-000000000051	LIFT-101	Lift 101	in_person	2025-08-07 11:38:31.466569+00	89	2025-08-07 11:38:31.466569+00
d3000001-0000-4000-8000-000000000110	d1000001-0000-4000-8000-000000000052	FORK-201	Forklift 201	hybrid	2025-08-05 11:38:31.466569+00	92	2025-08-05 11:38:31.466569+00
d3000001-0000-4000-8000-000000000111	d1000001-0000-4000-8000-000000000053	REACH-101	Reach 101	online	2025-08-03 11:38:31.466569+00	95	2025-08-03 11:38:31.466569+00
d3000001-0000-4000-8000-000000000112	d1000001-0000-4000-8000-000000000054	SAFE-OPS	Safe Operations	in_person	2025-08-01 11:38:31.466569+00	70	2025-08-01 11:38:31.466569+00
d3000001-0000-4000-8000-000000000113	d1000001-0000-4000-8000-000000000055	LIFT-101	Lift 101	hybrid	2025-07-30 11:38:31.466569+00	73	2025-07-30 11:38:31.466569+00
d3000001-0000-4000-8000-000000000114	d1000001-0000-4000-8000-000000000056	FORK-201	Forklift 201	online	2025-07-28 11:38:31.466569+00	76	2025-07-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000115	d1000001-0000-4000-8000-000000000057	REACH-101	Reach 101	in_person	2025-07-26 11:38:31.466569+00	79	2025-07-26 11:38:31.466569+00
d3000001-0000-4000-8000-000000000116	d1000001-0000-4000-8000-000000000058	SAFE-OPS	Safe Operations	hybrid	2025-07-24 11:38:31.466569+00	82	2025-07-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000117	d1000001-0000-4000-8000-000000000059	LIFT-101	Lift 101	online	2025-07-22 11:38:31.466569+00	85	2025-07-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000118	d1000001-0000-4000-8000-00000000005a	FORK-201	Forklift 201	in_person	2025-07-20 11:38:31.466569+00	88	2025-07-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000119	d1000001-0000-4000-8000-00000000005b	REACH-101	Reach 101	hybrid	2025-07-18 11:38:31.466569+00	91	2025-07-18 11:38:31.466569+00
d3000001-0000-4000-8000-00000000011a	d1000001-0000-4000-8000-00000000005c	SAFE-OPS	Safe Operations	online	2025-07-16 11:38:31.466569+00	94	2025-07-16 11:38:31.466569+00
d3000001-0000-4000-8000-00000000011b	d1000001-0000-4000-8000-00000000005d	LIFT-101	Lift 101	in_person	2025-07-14 11:38:31.466569+00	97	2025-07-14 11:38:31.466569+00
d3000001-0000-4000-8000-00000000011c	d1000001-0000-4000-8000-00000000005e	FORK-201	Forklift 201	hybrid	2025-07-12 11:38:31.466569+00	72	2025-07-12 11:38:31.466569+00
d3000001-0000-4000-8000-00000000011d	d1000001-0000-4000-8000-00000000005f	REACH-101	Reach 101	online	2025-07-10 11:38:31.466569+00	75	2025-07-10 11:38:31.466569+00
d3000001-0000-4000-8000-00000000011e	d1000001-0000-4000-8000-000000000060	SAFE-OPS	Safe Operations	in_person	2025-07-08 11:38:31.466569+00	78	2025-07-08 11:38:31.466569+00
d3000001-0000-4000-8000-00000000011f	d1000001-0000-4000-8000-000000000061	LIFT-101	Lift 101	hybrid	2025-07-06 11:38:31.466569+00	81	2025-07-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000120	d1000001-0000-4000-8000-000000000062	FORK-201	Forklift 201	online	2025-07-04 11:38:31.466569+00	84	2025-07-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000121	d1000001-0000-4000-8000-000000000063	REACH-101	Reach 101	in_person	2025-07-02 11:38:31.466569+00	87	2025-07-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000122	d1000001-0000-4000-8000-000000000064	SAFE-OPS	Safe Operations	hybrid	2025-06-30 11:38:31.466569+00	90	2025-06-30 11:38:31.466569+00
d3000001-0000-4000-8000-000000000123	d1000001-0000-4000-8000-000000000065	LIFT-101	Lift 101	online	2025-06-28 11:38:31.466569+00	93	2025-06-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000124	d1000001-0000-4000-8000-000000000066	FORK-201	Forklift 201	in_person	2025-06-26 11:38:31.466569+00	96	2025-06-26 11:38:31.466569+00
d3000001-0000-4000-8000-000000000125	d1000001-0000-4000-8000-000000000067	REACH-101	Reach 101	hybrid	2025-06-24 11:38:31.466569+00	71	2025-06-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000126	d1000001-0000-4000-8000-000000000068	SAFE-OPS	Safe Operations	online	2025-06-22 11:38:31.466569+00	74	2025-06-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000127	d1000001-0000-4000-8000-000000000069	LIFT-101	Lift 101	in_person	2025-06-20 11:38:31.466569+00	77	2025-06-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000128	d1000001-0000-4000-8000-00000000006a	FORK-201	Forklift 201	hybrid	2025-06-18 11:38:31.466569+00	80	2025-06-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000129	d1000001-0000-4000-8000-00000000006b	REACH-101	Reach 101	online	2025-06-16 11:38:31.466569+00	83	2025-06-16 11:38:31.466569+00
d3000001-0000-4000-8000-00000000012a	d1000001-0000-4000-8000-00000000006c	SAFE-OPS	Safe Operations	in_person	2025-06-14 11:38:31.466569+00	86	2025-06-14 11:38:31.466569+00
d3000001-0000-4000-8000-00000000012b	d1000001-0000-4000-8000-00000000006d	LIFT-101	Lift 101	hybrid	2025-06-12 11:38:31.466569+00	89	2025-06-12 11:38:31.466569+00
d3000001-0000-4000-8000-00000000012c	d1000001-0000-4000-8000-00000000006e	FORK-201	Forklift 201	online	2025-06-10 11:38:31.466569+00	92	2025-06-10 11:38:31.466569+00
d3000001-0000-4000-8000-00000000012d	d1000001-0000-4000-8000-00000000006f	REACH-101	Reach 101	in_person	2025-06-08 11:38:31.466569+00	95	2025-06-08 11:38:31.466569+00
d3000001-0000-4000-8000-00000000012e	d1000001-0000-4000-8000-000000000070	SAFE-OPS	Safe Operations	hybrid	2025-06-06 11:38:31.466569+00	70	2025-06-06 11:38:31.466569+00
d3000001-0000-4000-8000-00000000012f	d1000001-0000-4000-8000-000000000071	LIFT-101	Lift 101	online	2025-06-04 11:38:31.466569+00	73	2025-06-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000130	d1000001-0000-4000-8000-000000000072	FORK-201	Forklift 201	in_person	2025-06-02 11:38:31.466569+00	76	2025-06-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000131	d1000001-0000-4000-8000-000000000073	REACH-101	Reach 101	hybrid	2025-05-31 11:38:31.466569+00	79	2025-05-31 11:38:31.466569+00
d3000001-0000-4000-8000-000000000132	d1000001-0000-4000-8000-000000000074	SAFE-OPS	Safe Operations	online	2025-05-29 11:38:31.466569+00	82	2025-05-29 11:38:31.466569+00
d3000001-0000-4000-8000-000000000133	d1000001-0000-4000-8000-000000000075	LIFT-101	Lift 101	in_person	2025-05-27 11:38:31.466569+00	85	2025-05-27 11:38:31.466569+00
d3000001-0000-4000-8000-000000000134	d1000001-0000-4000-8000-000000000076	FORK-201	Forklift 201	hybrid	2025-05-25 11:38:31.466569+00	88	2025-05-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000135	d1000001-0000-4000-8000-000000000077	REACH-101	Reach 101	online	2025-05-23 11:38:31.466569+00	91	2025-05-23 11:38:31.466569+00
d3000001-0000-4000-8000-000000000136	d1000001-0000-4000-8000-000000000078	SAFE-OPS	Safe Operations	in_person	2025-05-21 11:38:31.466569+00	94	2025-05-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000137	d1000001-0000-4000-8000-000000000079	LIFT-101	Lift 101	hybrid	2025-05-19 11:38:31.466569+00	97	2025-05-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000138	d1000001-0000-4000-8000-00000000007a	FORK-201	Forklift 201	online	2025-05-17 11:38:31.466569+00	72	2025-05-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000139	d1000001-0000-4000-8000-00000000007b	REACH-101	Reach 101	in_person	2025-05-15 11:38:31.466569+00	75	2025-05-15 11:38:31.466569+00
d3000001-0000-4000-8000-00000000013a	d1000001-0000-4000-8000-00000000007c	SAFE-OPS	Safe Operations	hybrid	2025-05-13 11:38:31.466569+00	78	2025-05-13 11:38:31.466569+00
d3000001-0000-4000-8000-00000000013b	d1000001-0000-4000-8000-00000000007d	LIFT-101	Lift 101	online	2025-05-11 11:38:31.466569+00	81	2025-05-11 11:38:31.466569+00
d3000001-0000-4000-8000-00000000013c	d1000001-0000-4000-8000-00000000007e	FORK-201	Forklift 201	in_person	2025-05-09 11:38:31.466569+00	84	2025-05-09 11:38:31.466569+00
d3000001-0000-4000-8000-00000000013d	d1000001-0000-4000-8000-00000000007f	REACH-101	Reach 101	hybrid	2025-05-07 11:38:31.466569+00	87	2025-05-07 11:38:31.466569+00
d3000001-0000-4000-8000-00000000013e	d1000001-0000-4000-8000-000000000080	SAFE-OPS	Safe Operations	online	2025-05-05 11:38:31.466569+00	90	2025-05-05 11:38:31.466569+00
d3000001-0000-4000-8000-00000000013f	d1000001-0000-4000-8000-000000000081	LIFT-101	Lift 101	in_person	2025-05-03 11:38:31.466569+00	93	2025-05-03 11:38:31.466569+00
d3000001-0000-4000-8000-000000000140	d1000001-0000-4000-8000-000000000082	FORK-201	Forklift 201	hybrid	2025-05-01 11:38:31.466569+00	96	2025-05-01 11:38:31.466569+00
d3000001-0000-4000-8000-000000000141	d1000001-0000-4000-8000-000000000083	REACH-101	Reach 101	online	2025-04-29 11:38:31.466569+00	71	2025-04-29 11:38:31.466569+00
d3000001-0000-4000-8000-000000000142	d1000001-0000-4000-8000-000000000084	SAFE-OPS	Safe Operations	in_person	2025-04-27 11:38:31.466569+00	74	2025-04-27 11:38:31.466569+00
d3000001-0000-4000-8000-000000000143	d1000001-0000-4000-8000-000000000085	LIFT-101	Lift 101	hybrid	2025-04-25 11:38:31.466569+00	77	2025-04-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000144	d1000001-0000-4000-8000-000000000086	FORK-201	Forklift 201	online	2025-04-23 11:38:31.466569+00	80	2025-04-23 11:38:31.466569+00
d3000001-0000-4000-8000-000000000145	d1000001-0000-4000-8000-000000000087	REACH-101	Reach 101	in_person	2025-04-21 11:38:31.466569+00	83	2025-04-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000146	d1000001-0000-4000-8000-000000000088	SAFE-OPS	Safe Operations	hybrid	2025-04-19 11:38:31.466569+00	86	2025-04-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000147	d1000001-0000-4000-8000-000000000089	LIFT-101	Lift 101	online	2025-04-17 11:38:31.466569+00	89	2025-04-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000148	d1000001-0000-4000-8000-00000000008a	FORK-201	Forklift 201	in_person	2025-04-15 11:38:31.466569+00	92	2025-04-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000149	d1000001-0000-4000-8000-00000000008b	REACH-101	Reach 101	hybrid	2025-04-13 11:38:31.466569+00	95	2025-04-13 11:38:31.466569+00
d3000001-0000-4000-8000-00000000014a	d1000001-0000-4000-8000-00000000008c	SAFE-OPS	Safe Operations	online	2025-04-11 11:38:31.466569+00	70	2025-04-11 11:38:31.466569+00
d3000001-0000-4000-8000-00000000014b	d1000001-0000-4000-8000-00000000008d	LIFT-101	Lift 101	in_person	2025-04-09 11:38:31.466569+00	73	2025-04-09 11:38:31.466569+00
d3000001-0000-4000-8000-00000000014c	d1000001-0000-4000-8000-00000000008e	FORK-201	Forklift 201	hybrid	2025-04-07 11:38:31.466569+00	76	2025-04-07 11:38:31.466569+00
d3000001-0000-4000-8000-00000000014d	d1000001-0000-4000-8000-00000000008f	REACH-101	Reach 101	online	2025-04-05 11:38:31.466569+00	79	2025-04-05 11:38:31.466569+00
d3000001-0000-4000-8000-00000000014e	d1000001-0000-4000-8000-000000000090	SAFE-OPS	Safe Operations	in_person	2025-04-03 11:38:31.466569+00	82	2025-04-03 11:38:31.466569+00
d3000001-0000-4000-8000-00000000014f	d1000001-0000-4000-8000-000000000091	LIFT-101	Lift 101	hybrid	2025-04-01 11:38:31.466569+00	85	2025-04-01 11:38:31.466569+00
d3000001-0000-4000-8000-000000000150	d1000001-0000-4000-8000-000000000092	FORK-201	Forklift 201	online	2025-03-30 11:38:31.466569+00	88	2025-03-30 11:38:31.466569+00
d3000001-0000-4000-8000-000000000151	d1000001-0000-4000-8000-000000000093	REACH-101	Reach 101	in_person	2025-03-28 11:38:31.466569+00	91	2025-03-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000152	d1000001-0000-4000-8000-000000000094	SAFE-OPS	Safe Operations	hybrid	2025-03-26 11:38:31.466569+00	94	2025-03-26 11:38:31.466569+00
d3000001-0000-4000-8000-000000000153	d1000001-0000-4000-8000-000000000095	LIFT-101	Lift 101	online	2025-03-24 11:38:31.466569+00	97	2025-03-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000154	d1000001-0000-4000-8000-000000000096	FORK-201	Forklift 201	in_person	2025-03-22 11:38:31.466569+00	72	2025-03-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000155	d1000001-0000-4000-8000-000000000097	REACH-101	Reach 101	hybrid	2025-03-20 11:38:31.466569+00	75	2025-03-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000156	d1000001-0000-4000-8000-000000000098	SAFE-OPS	Safe Operations	online	2025-03-18 11:38:31.466569+00	78	2025-03-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000157	d1000001-0000-4000-8000-000000000099	LIFT-101	Lift 101	in_person	2025-03-16 11:38:31.466569+00	81	2025-03-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000158	d1000001-0000-4000-8000-00000000009a	FORK-201	Forklift 201	hybrid	2025-03-14 11:38:31.466569+00	84	2025-03-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000159	d1000001-0000-4000-8000-00000000009b	REACH-101	Reach 101	online	2025-03-12 11:38:31.466569+00	87	2025-03-12 11:38:31.466569+00
d3000001-0000-4000-8000-00000000015a	d1000001-0000-4000-8000-00000000009c	SAFE-OPS	Safe Operations	in_person	2025-03-10 11:38:31.466569+00	90	2025-03-10 11:38:31.466569+00
d3000001-0000-4000-8000-00000000015b	d1000001-0000-4000-8000-00000000009d	LIFT-101	Lift 101	hybrid	2025-03-08 11:38:31.466569+00	93	2025-03-08 11:38:31.466569+00
d3000001-0000-4000-8000-00000000015c	d1000001-0000-4000-8000-00000000009e	FORK-201	Forklift 201	online	2025-03-06 11:38:31.466569+00	96	2025-03-06 11:38:31.466569+00
d3000001-0000-4000-8000-00000000015d	d1000001-0000-4000-8000-00000000009f	REACH-101	Reach 101	in_person	2025-03-04 11:38:31.466569+00	71	2025-03-04 11:38:31.466569+00
d3000001-0000-4000-8000-00000000015e	d1000001-0000-4000-8000-0000000000a0	SAFE-OPS	Safe Operations	hybrid	2025-03-02 11:38:31.466569+00	74	2025-03-02 11:38:31.466569+00
d3000001-0000-4000-8000-00000000015f	d1000001-0000-4000-8000-0000000000a1	LIFT-101	Lift 101	online	2025-02-28 11:38:31.466569+00	77	2025-02-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000160	d1000001-0000-4000-8000-0000000000a2	FORK-201	Forklift 201	in_person	2025-02-26 11:38:31.466569+00	80	2025-02-26 11:38:31.466569+00
d3000001-0000-4000-8000-000000000161	d1000001-0000-4000-8000-0000000000a3	REACH-101	Reach 101	hybrid	2026-02-24 11:38:31.466569+00	83	2026-02-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000162	d1000001-0000-4000-8000-0000000000a4	SAFE-OPS	Safe Operations	online	2026-02-22 11:38:31.466569+00	86	2026-02-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000163	d1000001-0000-4000-8000-0000000000a5	LIFT-101	Lift 101	in_person	2026-02-20 11:38:31.466569+00	89	2026-02-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000164	d1000001-0000-4000-8000-0000000000a6	FORK-201	Forklift 201	hybrid	2026-02-18 11:38:31.466569+00	92	2026-02-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000165	d1000001-0000-4000-8000-0000000000a7	REACH-101	Reach 101	online	2026-02-16 11:38:31.466569+00	95	2026-02-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000166	d1000001-0000-4000-8000-0000000000a8	SAFE-OPS	Safe Operations	in_person	2026-02-14 11:38:31.466569+00	70	2026-02-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000167	d1000001-0000-4000-8000-0000000000a9	LIFT-101	Lift 101	hybrid	2026-02-12 11:38:31.466569+00	73	2026-02-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000168	d1000001-0000-4000-8000-0000000000aa	FORK-201	Forklift 201	online	2026-02-10 11:38:31.466569+00	76	2026-02-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000169	d1000001-0000-4000-8000-0000000000ab	REACH-101	Reach 101	in_person	2026-02-08 11:38:31.466569+00	79	2026-02-08 11:38:31.466569+00
d3000001-0000-4000-8000-00000000016a	d1000001-0000-4000-8000-0000000000ac	SAFE-OPS	Safe Operations	hybrid	2026-02-06 11:38:31.466569+00	82	2026-02-06 11:38:31.466569+00
d3000001-0000-4000-8000-00000000016b	d1000001-0000-4000-8000-0000000000ad	LIFT-101	Lift 101	online	2026-02-04 11:38:31.466569+00	85	2026-02-04 11:38:31.466569+00
d3000001-0000-4000-8000-00000000016c	d1000001-0000-4000-8000-0000000000ae	FORK-201	Forklift 201	in_person	2026-02-02 11:38:31.466569+00	88	2026-02-02 11:38:31.466569+00
d3000001-0000-4000-8000-00000000016d	d1000001-0000-4000-8000-0000000000af	REACH-101	Reach 101	hybrid	2026-01-31 11:38:31.466569+00	91	2026-01-31 11:38:31.466569+00
d3000001-0000-4000-8000-00000000016e	d1000001-0000-4000-8000-0000000000b0	SAFE-OPS	Safe Operations	online	2026-01-29 11:38:31.466569+00	94	2026-01-29 11:38:31.466569+00
d3000001-0000-4000-8000-00000000016f	d1000001-0000-4000-8000-0000000000b1	LIFT-101	Lift 101	in_person	2026-01-27 11:38:31.466569+00	97	2026-01-27 11:38:31.466569+00
d3000001-0000-4000-8000-000000000170	d1000001-0000-4000-8000-0000000000b2	FORK-201	Forklift 201	hybrid	2026-01-25 11:38:31.466569+00	72	2026-01-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000171	d1000001-0000-4000-8000-0000000000b3	REACH-101	Reach 101	online	2026-01-23 11:38:31.466569+00	75	2026-01-23 11:38:31.466569+00
d3000001-0000-4000-8000-000000000172	d1000001-0000-4000-8000-0000000000b4	SAFE-OPS	Safe Operations	in_person	2026-01-21 11:38:31.466569+00	78	2026-01-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000173	d1000001-0000-4000-8000-0000000000b5	LIFT-101	Lift 101	hybrid	2026-01-19 11:38:31.466569+00	81	2026-01-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000174	d1000001-0000-4000-8000-0000000000b6	FORK-201	Forklift 201	online	2026-01-17 11:38:31.466569+00	84	2026-01-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000175	d1000001-0000-4000-8000-0000000000b7	REACH-101	Reach 101	in_person	2026-01-15 11:38:31.466569+00	87	2026-01-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000176	d1000001-0000-4000-8000-0000000000b8	SAFE-OPS	Safe Operations	hybrid	2026-01-13 11:38:31.466569+00	90	2026-01-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000177	d1000001-0000-4000-8000-0000000000b9	LIFT-101	Lift 101	online	2026-01-11 11:38:31.466569+00	93	2026-01-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000178	d1000001-0000-4000-8000-0000000000ba	FORK-201	Forklift 201	in_person	2026-01-09 11:38:31.466569+00	96	2026-01-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000179	d1000001-0000-4000-8000-0000000000bb	REACH-101	Reach 101	hybrid	2026-01-07 11:38:31.466569+00	71	2026-01-07 11:38:31.466569+00
d3000001-0000-4000-8000-00000000017a	d1000001-0000-4000-8000-0000000000bc	SAFE-OPS	Safe Operations	online	2026-01-05 11:38:31.466569+00	74	2026-01-05 11:38:31.466569+00
d3000001-0000-4000-8000-00000000017b	d1000001-0000-4000-8000-0000000000bd	LIFT-101	Lift 101	in_person	2026-01-03 11:38:31.466569+00	77	2026-01-03 11:38:31.466569+00
d3000001-0000-4000-8000-00000000017c	d1000001-0000-4000-8000-0000000000be	FORK-201	Forklift 201	hybrid	2026-01-01 11:38:31.466569+00	80	2026-01-01 11:38:31.466569+00
d3000001-0000-4000-8000-00000000017d	d1000001-0000-4000-8000-0000000000bf	REACH-101	Reach 101	online	2025-12-30 11:38:31.466569+00	83	2025-12-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000017e	d1000001-0000-4000-8000-0000000000c0	SAFE-OPS	Safe Operations	in_person	2025-12-28 11:38:31.466569+00	86	2025-12-28 11:38:31.466569+00
d3000001-0000-4000-8000-00000000017f	d1000001-0000-4000-8000-0000000000c1	LIFT-101	Lift 101	hybrid	2025-12-26 11:38:31.466569+00	89	2025-12-26 11:38:31.466569+00
d3000001-0000-4000-8000-000000000180	d1000001-0000-4000-8000-0000000000c2	FORK-201	Forklift 201	online	2025-12-24 11:38:31.466569+00	92	2025-12-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000181	d1000001-0000-4000-8000-0000000000c3	REACH-101	Reach 101	in_person	2025-12-22 11:38:31.466569+00	95	2025-12-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000182	d1000001-0000-4000-8000-0000000000c4	SAFE-OPS	Safe Operations	hybrid	2025-12-20 11:38:31.466569+00	70	2025-12-20 11:38:31.466569+00
d3000001-0000-4000-8000-000000000183	d1000001-0000-4000-8000-0000000000c5	LIFT-101	Lift 101	online	2025-12-18 11:38:31.466569+00	73	2025-12-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000184	d1000001-0000-4000-8000-0000000000c6	FORK-201	Forklift 201	in_person	2025-12-16 11:38:31.466569+00	76	2025-12-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000185	d1000001-0000-4000-8000-0000000000c7	REACH-101	Reach 101	hybrid	2025-12-14 11:38:31.466569+00	79	2025-12-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000186	d1000001-0000-4000-8000-0000000000c8	SAFE-OPS	Safe Operations	online	2025-12-12 11:38:31.466569+00	82	2025-12-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000187	d1000001-0000-4000-8000-0000000000c9	LIFT-101	Lift 101	in_person	2025-12-10 11:38:31.466569+00	85	2025-12-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000188	d1000001-0000-4000-8000-0000000000ca	FORK-201	Forklift 201	hybrid	2025-12-08 11:38:31.466569+00	88	2025-12-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000189	d1000001-0000-4000-8000-0000000000cb	REACH-101	Reach 101	online	2025-12-06 11:38:31.466569+00	91	2025-12-06 11:38:31.466569+00
d3000001-0000-4000-8000-00000000018a	d1000001-0000-4000-8000-0000000000cc	SAFE-OPS	Safe Operations	in_person	2025-12-04 11:38:31.466569+00	94	2025-12-04 11:38:31.466569+00
d3000001-0000-4000-8000-00000000018b	d1000001-0000-4000-8000-0000000000cd	LIFT-101	Lift 101	hybrid	2025-12-02 11:38:31.466569+00	97	2025-12-02 11:38:31.466569+00
d3000001-0000-4000-8000-00000000018c	d1000001-0000-4000-8000-0000000000ce	FORK-201	Forklift 201	online	2025-11-30 11:38:31.466569+00	72	2025-11-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000018d	d1000001-0000-4000-8000-0000000000cf	REACH-101	Reach 101	in_person	2025-11-28 11:38:31.466569+00	75	2025-11-28 11:38:31.466569+00
d3000001-0000-4000-8000-00000000018e	d1000001-0000-4000-8000-0000000000d0	SAFE-OPS	Safe Operations	hybrid	2025-11-26 11:38:31.466569+00	78	2025-11-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000018f	d1000001-0000-4000-8000-0000000000d1	LIFT-101	Lift 101	online	2025-11-24 11:38:31.466569+00	81	2025-11-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000190	d1000001-0000-4000-8000-0000000000d2	FORK-201	Forklift 201	in_person	2025-11-22 11:38:31.466569+00	84	2025-11-22 11:38:31.466569+00
d3000001-0000-4000-8000-000000000191	d1000001-0000-4000-8000-00000000000b	SAFE-OPS	Safe Operations	in_person	2025-11-25 11:38:31.466569+00	76	2025-11-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000192	d1000001-0000-4000-8000-00000000000c	LIFT-101	Lift 101	hybrid	2025-11-23 11:38:31.466569+00	79	2025-11-23 11:38:31.466569+00
d3000001-0000-4000-8000-000000000193	d1000001-0000-4000-8000-00000000000d	FORK-201	Forklift 201	online	2025-11-21 11:38:31.466569+00	82	2025-11-21 11:38:31.466569+00
d3000001-0000-4000-8000-000000000194	d1000001-0000-4000-8000-00000000000e	REACH-101	Reach 101	in_person	2025-11-19 11:38:31.466569+00	85	2025-11-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000195	d1000001-0000-4000-8000-00000000000f	SAFE-OPS	Safe Operations	hybrid	2025-11-17 11:38:31.466569+00	88	2025-11-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000196	d1000001-0000-4000-8000-000000000010	LIFT-101	Lift 101	online	2025-11-15 11:38:31.466569+00	91	2025-11-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000197	d1000001-0000-4000-8000-000000000011	FORK-201	Forklift 201	in_person	2025-11-13 11:38:31.466569+00	94	2025-11-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000198	d1000001-0000-4000-8000-000000000012	REACH-101	Reach 101	hybrid	2025-11-11 11:38:31.466569+00	97	2025-11-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000199	d1000001-0000-4000-8000-000000000013	SAFE-OPS	Safe Operations	online	2025-11-09 11:38:31.466569+00	72	2025-11-09 11:38:31.466569+00
d3000001-0000-4000-8000-00000000019a	d1000001-0000-4000-8000-000000000014	LIFT-101	Lift 101	in_person	2025-11-07 11:38:31.466569+00	75	2025-11-07 11:38:31.466569+00
d3000001-0000-4000-8000-00000000019b	d1000001-0000-4000-8000-000000000015	FORK-201	Forklift 201	hybrid	2025-11-05 11:38:31.466569+00	78	2025-11-05 11:38:31.466569+00
d3000001-0000-4000-8000-00000000019c	d1000001-0000-4000-8000-000000000016	REACH-101	Reach 101	online	2025-11-03 11:38:31.466569+00	81	2025-11-03 11:38:31.466569+00
d3000001-0000-4000-8000-00000000019d	d1000001-0000-4000-8000-000000000017	SAFE-OPS	Safe Operations	in_person	2025-11-01 11:38:31.466569+00	84	2025-11-01 11:38:31.466569+00
d3000001-0000-4000-8000-00000000019e	d1000001-0000-4000-8000-000000000018	LIFT-101	Lift 101	hybrid	2025-10-30 11:38:31.466569+00	87	2025-10-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000019f	d1000001-0000-4000-8000-000000000019	FORK-201	Forklift 201	online	2025-10-28 11:38:31.466569+00	90	2025-10-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a0	d1000001-0000-4000-8000-00000000001a	REACH-101	Reach 101	in_person	2025-10-26 11:38:31.466569+00	93	2025-10-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a1	d1000001-0000-4000-8000-00000000001b	SAFE-OPS	Safe Operations	hybrid	2025-10-24 11:38:31.466569+00	96	2025-10-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a2	d1000001-0000-4000-8000-00000000001c	LIFT-101	Lift 101	online	2025-10-22 11:38:31.466569+00	71	2025-10-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a3	d1000001-0000-4000-8000-00000000001d	FORK-201	Forklift 201	in_person	2025-10-20 11:38:31.466569+00	74	2025-10-20 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a4	d1000001-0000-4000-8000-00000000001e	REACH-101	Reach 101	hybrid	2025-10-18 11:38:31.466569+00	77	2025-10-18 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a5	d1000001-0000-4000-8000-00000000001f	SAFE-OPS	Safe Operations	online	2025-10-16 11:38:31.466569+00	80	2025-10-16 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a6	d1000001-0000-4000-8000-000000000020	LIFT-101	Lift 101	in_person	2025-10-14 11:38:31.466569+00	83	2025-10-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a7	d1000001-0000-4000-8000-000000000021	FORK-201	Forklift 201	hybrid	2025-10-12 11:38:31.466569+00	86	2025-10-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a8	d1000001-0000-4000-8000-000000000022	REACH-101	Reach 101	online	2025-10-10 11:38:31.466569+00	89	2025-10-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001a9	d1000001-0000-4000-8000-000000000023	SAFE-OPS	Safe Operations	in_person	2025-10-08 11:38:31.466569+00	92	2025-10-08 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001aa	d1000001-0000-4000-8000-000000000024	LIFT-101	Lift 101	hybrid	2025-10-06 11:38:31.466569+00	95	2025-10-06 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ab	d1000001-0000-4000-8000-000000000025	FORK-201	Forklift 201	online	2025-10-04 11:38:31.466569+00	70	2025-10-04 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ac	d1000001-0000-4000-8000-000000000026	REACH-101	Reach 101	in_person	2025-10-02 11:38:31.466569+00	73	2025-10-02 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ad	d1000001-0000-4000-8000-000000000027	SAFE-OPS	Safe Operations	hybrid	2025-09-30 11:38:31.466569+00	76	2025-09-30 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ae	d1000001-0000-4000-8000-000000000028	LIFT-101	Lift 101	online	2025-09-28 11:38:31.466569+00	79	2025-09-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001af	d1000001-0000-4000-8000-000000000029	FORK-201	Forklift 201	in_person	2025-09-26 11:38:31.466569+00	82	2025-09-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b0	d1000001-0000-4000-8000-00000000002a	REACH-101	Reach 101	hybrid	2025-09-24 11:38:31.466569+00	85	2025-09-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b1	d1000001-0000-4000-8000-00000000002b	SAFE-OPS	Safe Operations	online	2025-09-22 11:38:31.466569+00	88	2025-09-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b2	d1000001-0000-4000-8000-00000000002c	LIFT-101	Lift 101	in_person	2025-09-20 11:38:31.466569+00	91	2025-09-20 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b3	d1000001-0000-4000-8000-00000000002d	FORK-201	Forklift 201	hybrid	2025-09-18 11:38:31.466569+00	94	2025-09-18 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b4	d1000001-0000-4000-8000-00000000002e	REACH-101	Reach 101	online	2025-09-16 11:38:31.466569+00	97	2025-09-16 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b5	d1000001-0000-4000-8000-00000000002f	SAFE-OPS	Safe Operations	in_person	2025-09-14 11:38:31.466569+00	72	2025-09-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b6	d1000001-0000-4000-8000-000000000030	LIFT-101	Lift 101	hybrid	2025-09-12 11:38:31.466569+00	75	2025-09-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b7	d1000001-0000-4000-8000-000000000031	FORK-201	Forklift 201	online	2025-09-10 11:38:31.466569+00	78	2025-09-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b8	d1000001-0000-4000-8000-000000000032	REACH-101	Reach 101	in_person	2025-09-08 11:38:31.466569+00	81	2025-09-08 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001b9	d1000001-0000-4000-8000-000000000033	SAFE-OPS	Safe Operations	hybrid	2025-09-06 11:38:31.466569+00	84	2025-09-06 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ba	d1000001-0000-4000-8000-000000000034	LIFT-101	Lift 101	online	2025-09-04 11:38:31.466569+00	87	2025-09-04 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001bb	d1000001-0000-4000-8000-000000000035	FORK-201	Forklift 201	in_person	2025-09-02 11:38:31.466569+00	90	2025-09-02 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001bc	d1000001-0000-4000-8000-000000000036	REACH-101	Reach 101	hybrid	2025-08-31 11:38:31.466569+00	93	2025-08-31 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001bd	d1000001-0000-4000-8000-000000000037	SAFE-OPS	Safe Operations	online	2025-08-29 11:38:31.466569+00	96	2025-08-29 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001be	d1000001-0000-4000-8000-000000000038	LIFT-101	Lift 101	in_person	2025-08-27 11:38:31.466569+00	71	2025-08-27 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001bf	d1000001-0000-4000-8000-000000000039	FORK-201	Forklift 201	hybrid	2025-08-25 11:38:31.466569+00	74	2025-08-25 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c0	d1000001-0000-4000-8000-00000000003a	REACH-101	Reach 101	online	2025-08-23 11:38:31.466569+00	77	2025-08-23 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c1	d1000001-0000-4000-8000-00000000003b	SAFE-OPS	Safe Operations	in_person	2025-08-21 11:38:31.466569+00	80	2025-08-21 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c2	d1000001-0000-4000-8000-00000000003c	LIFT-101	Lift 101	hybrid	2025-08-19 11:38:31.466569+00	83	2025-08-19 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c3	d1000001-0000-4000-8000-00000000003d	FORK-201	Forklift 201	online	2025-08-17 11:38:31.466569+00	86	2025-08-17 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c4	d1000001-0000-4000-8000-00000000003e	REACH-101	Reach 101	in_person	2025-08-15 11:38:31.466569+00	89	2025-08-15 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c5	d1000001-0000-4000-8000-00000000003f	SAFE-OPS	Safe Operations	hybrid	2025-08-13 11:38:31.466569+00	92	2025-08-13 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c6	d1000001-0000-4000-8000-000000000040	LIFT-101	Lift 101	online	2025-08-11 11:38:31.466569+00	95	2025-08-11 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c7	d1000001-0000-4000-8000-000000000041	FORK-201	Forklift 201	in_person	2025-08-09 11:38:31.466569+00	70	2025-08-09 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c8	d1000001-0000-4000-8000-000000000042	REACH-101	Reach 101	hybrid	2025-08-07 11:38:31.466569+00	73	2025-08-07 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001c9	d1000001-0000-4000-8000-000000000043	SAFE-OPS	Safe Operations	online	2025-08-05 11:38:31.466569+00	76	2025-08-05 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ca	d1000001-0000-4000-8000-000000000044	LIFT-101	Lift 101	in_person	2025-08-03 11:38:31.466569+00	79	2025-08-03 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001cb	d1000001-0000-4000-8000-000000000045	FORK-201	Forklift 201	hybrid	2025-08-01 11:38:31.466569+00	82	2025-08-01 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001cc	d1000001-0000-4000-8000-000000000046	REACH-101	Reach 101	online	2025-07-30 11:38:31.466569+00	85	2025-07-30 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001cd	d1000001-0000-4000-8000-000000000047	SAFE-OPS	Safe Operations	in_person	2025-07-28 11:38:31.466569+00	88	2025-07-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ce	d1000001-0000-4000-8000-000000000048	LIFT-101	Lift 101	hybrid	2025-07-26 11:38:31.466569+00	91	2025-07-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001cf	d1000001-0000-4000-8000-000000000049	FORK-201	Forklift 201	online	2025-07-24 11:38:31.466569+00	94	2025-07-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d0	d1000001-0000-4000-8000-00000000004a	REACH-101	Reach 101	in_person	2025-07-22 11:38:31.466569+00	97	2025-07-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d1	d1000001-0000-4000-8000-00000000004b	SAFE-OPS	Safe Operations	hybrid	2025-07-20 11:38:31.466569+00	72	2025-07-20 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d2	d1000001-0000-4000-8000-00000000004c	LIFT-101	Lift 101	online	2025-07-18 11:38:31.466569+00	75	2025-07-18 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d3	d1000001-0000-4000-8000-00000000004d	FORK-201	Forklift 201	in_person	2025-07-16 11:38:31.466569+00	78	2025-07-16 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d4	d1000001-0000-4000-8000-00000000004e	REACH-101	Reach 101	hybrid	2025-07-14 11:38:31.466569+00	81	2025-07-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d5	d1000001-0000-4000-8000-00000000004f	SAFE-OPS	Safe Operations	online	2025-07-12 11:38:31.466569+00	84	2025-07-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d6	d1000001-0000-4000-8000-000000000050	LIFT-101	Lift 101	in_person	2025-07-10 11:38:31.466569+00	87	2025-07-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d7	d1000001-0000-4000-8000-000000000051	FORK-201	Forklift 201	hybrid	2025-07-08 11:38:31.466569+00	90	2025-07-08 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d8	d1000001-0000-4000-8000-000000000052	REACH-101	Reach 101	online	2025-07-06 11:38:31.466569+00	93	2025-07-06 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001d9	d1000001-0000-4000-8000-000000000053	SAFE-OPS	Safe Operations	in_person	2025-07-04 11:38:31.466569+00	96	2025-07-04 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001da	d1000001-0000-4000-8000-000000000054	LIFT-101	Lift 101	hybrid	2025-07-02 11:38:31.466569+00	71	2025-07-02 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001db	d1000001-0000-4000-8000-000000000055	FORK-201	Forklift 201	online	2025-06-30 11:38:31.466569+00	74	2025-06-30 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001dc	d1000001-0000-4000-8000-000000000056	REACH-101	Reach 101	in_person	2025-06-28 11:38:31.466569+00	77	2025-06-28 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001dd	d1000001-0000-4000-8000-000000000057	SAFE-OPS	Safe Operations	hybrid	2025-06-26 11:38:31.466569+00	80	2025-06-26 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001de	d1000001-0000-4000-8000-000000000058	LIFT-101	Lift 101	online	2025-06-24 11:38:31.466569+00	83	2025-06-24 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001df	d1000001-0000-4000-8000-000000000059	FORK-201	Forklift 201	in_person	2025-06-22 11:38:31.466569+00	86	2025-06-22 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e0	d1000001-0000-4000-8000-00000000005a	REACH-101	Reach 101	hybrid	2025-06-20 11:38:31.466569+00	89	2025-06-20 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e1	d1000001-0000-4000-8000-00000000005b	SAFE-OPS	Safe Operations	online	2025-06-18 11:38:31.466569+00	92	2025-06-18 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e2	d1000001-0000-4000-8000-00000000005c	LIFT-101	Lift 101	in_person	2025-06-16 11:38:31.466569+00	95	2025-06-16 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e3	d1000001-0000-4000-8000-00000000005d	FORK-201	Forklift 201	hybrid	2025-06-14 11:38:31.466569+00	70	2025-06-14 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e4	d1000001-0000-4000-8000-00000000005e	REACH-101	Reach 101	online	2025-06-12 11:38:31.466569+00	73	2025-06-12 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e5	d1000001-0000-4000-8000-00000000005f	SAFE-OPS	Safe Operations	in_person	2025-06-10 11:38:31.466569+00	76	2025-06-10 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e6	d1000001-0000-4000-8000-000000000060	LIFT-101	Lift 101	hybrid	2025-06-08 11:38:31.466569+00	79	2025-06-08 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e7	d1000001-0000-4000-8000-000000000061	FORK-201	Forklift 201	online	2025-06-06 11:38:31.466569+00	82	2025-06-06 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e8	d1000001-0000-4000-8000-000000000062	REACH-101	Reach 101	in_person	2025-06-04 11:38:31.466569+00	85	2025-06-04 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001e9	d1000001-0000-4000-8000-000000000063	SAFE-OPS	Safe Operations	hybrid	2025-06-02 11:38:31.466569+00	88	2025-06-02 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ea	d1000001-0000-4000-8000-000000000064	LIFT-101	Lift 101	online	2025-05-31 11:38:31.466569+00	91	2025-05-31 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001eb	d1000001-0000-4000-8000-000000000065	FORK-201	Forklift 201	in_person	2025-05-29 11:38:31.466569+00	94	2025-05-29 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ec	d1000001-0000-4000-8000-000000000066	REACH-101	Reach 101	hybrid	2025-05-27 11:38:31.466569+00	97	2025-05-27 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ed	d1000001-0000-4000-8000-000000000067	SAFE-OPS	Safe Operations	online	2025-05-25 11:38:31.466569+00	72	2025-05-25 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ee	d1000001-0000-4000-8000-000000000068	LIFT-101	Lift 101	in_person	2025-05-23 11:38:31.466569+00	75	2025-05-23 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ef	d1000001-0000-4000-8000-000000000069	FORK-201	Forklift 201	hybrid	2025-05-21 11:38:31.466569+00	78	2025-05-21 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f0	d1000001-0000-4000-8000-00000000006a	REACH-101	Reach 101	online	2025-05-19 11:38:31.466569+00	81	2025-05-19 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f1	d1000001-0000-4000-8000-00000000006b	SAFE-OPS	Safe Operations	in_person	2025-05-17 11:38:31.466569+00	84	2025-05-17 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f2	d1000001-0000-4000-8000-00000000006c	LIFT-101	Lift 101	hybrid	2025-05-15 11:38:31.466569+00	87	2025-05-15 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f3	d1000001-0000-4000-8000-00000000006d	FORK-201	Forklift 201	online	2025-05-13 11:38:31.466569+00	90	2025-05-13 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f4	d1000001-0000-4000-8000-00000000006e	REACH-101	Reach 101	in_person	2025-05-11 11:38:31.466569+00	93	2025-05-11 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f5	d1000001-0000-4000-8000-00000000006f	SAFE-OPS	Safe Operations	hybrid	2025-05-09 11:38:31.466569+00	96	2025-05-09 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f6	d1000001-0000-4000-8000-000000000070	LIFT-101	Lift 101	online	2025-05-07 11:38:31.466569+00	71	2025-05-07 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f7	d1000001-0000-4000-8000-000000000071	FORK-201	Forklift 201	in_person	2025-05-05 11:38:31.466569+00	74	2025-05-05 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f8	d1000001-0000-4000-8000-000000000072	REACH-101	Reach 101	hybrid	2025-05-03 11:38:31.466569+00	77	2025-05-03 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001f9	d1000001-0000-4000-8000-000000000073	SAFE-OPS	Safe Operations	online	2025-05-01 11:38:31.466569+00	80	2025-05-01 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001fa	d1000001-0000-4000-8000-000000000074	LIFT-101	Lift 101	in_person	2025-04-29 11:38:31.466569+00	83	2025-04-29 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001fb	d1000001-0000-4000-8000-000000000075	FORK-201	Forklift 201	hybrid	2025-04-27 11:38:31.466569+00	86	2025-04-27 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001fc	d1000001-0000-4000-8000-000000000076	REACH-101	Reach 101	online	2025-04-25 11:38:31.466569+00	89	2025-04-25 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001fd	d1000001-0000-4000-8000-000000000077	SAFE-OPS	Safe Operations	in_person	2025-04-23 11:38:31.466569+00	92	2025-04-23 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001fe	d1000001-0000-4000-8000-000000000078	LIFT-101	Lift 101	hybrid	2025-04-21 11:38:31.466569+00	95	2025-04-21 11:38:31.466569+00
d3000001-0000-4000-8000-0000000001ff	d1000001-0000-4000-8000-000000000079	FORK-201	Forklift 201	online	2025-04-19 11:38:31.466569+00	70	2025-04-19 11:38:31.466569+00
d3000001-0000-4000-8000-000000000200	d1000001-0000-4000-8000-00000000007a	REACH-101	Reach 101	in_person	2025-04-17 11:38:31.466569+00	73	2025-04-17 11:38:31.466569+00
d3000001-0000-4000-8000-000000000201	d1000001-0000-4000-8000-00000000007b	SAFE-OPS	Safe Operations	hybrid	2025-04-15 11:38:31.466569+00	76	2025-04-15 11:38:31.466569+00
d3000001-0000-4000-8000-000000000202	d1000001-0000-4000-8000-00000000007c	LIFT-101	Lift 101	online	2025-04-13 11:38:31.466569+00	79	2025-04-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000203	d1000001-0000-4000-8000-00000000007d	FORK-201	Forklift 201	in_person	2025-04-11 11:38:31.466569+00	82	2025-04-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000204	d1000001-0000-4000-8000-00000000007e	REACH-101	Reach 101	hybrid	2025-04-09 11:38:31.466569+00	85	2025-04-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000205	d1000001-0000-4000-8000-00000000007f	SAFE-OPS	Safe Operations	online	2025-04-07 11:38:31.466569+00	88	2025-04-07 11:38:31.466569+00
d3000001-0000-4000-8000-000000000206	d1000001-0000-4000-8000-000000000080	LIFT-101	Lift 101	in_person	2025-04-05 11:38:31.466569+00	91	2025-04-05 11:38:31.466569+00
d3000001-0000-4000-8000-000000000207	d1000001-0000-4000-8000-000000000081	FORK-201	Forklift 201	hybrid	2025-04-03 11:38:31.466569+00	94	2025-04-03 11:38:31.466569+00
d3000001-0000-4000-8000-000000000208	d1000001-0000-4000-8000-000000000082	REACH-101	Reach 101	online	2025-04-01 11:38:31.466569+00	97	2025-04-01 11:38:31.466569+00
d3000001-0000-4000-8000-000000000209	d1000001-0000-4000-8000-000000000083	SAFE-OPS	Safe Operations	in_person	2025-03-30 11:38:31.466569+00	72	2025-03-30 11:38:31.466569+00
d3000001-0000-4000-8000-00000000020a	d1000001-0000-4000-8000-000000000084	LIFT-101	Lift 101	hybrid	2025-03-28 11:38:31.466569+00	75	2025-03-28 11:38:31.466569+00
d3000001-0000-4000-8000-00000000020b	d1000001-0000-4000-8000-000000000085	FORK-201	Forklift 201	online	2025-03-26 11:38:31.466569+00	78	2025-03-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000020c	d1000001-0000-4000-8000-000000000086	REACH-101	Reach 101	in_person	2025-03-24 11:38:31.466569+00	81	2025-03-24 11:38:31.466569+00
d3000001-0000-4000-8000-00000000020d	d1000001-0000-4000-8000-000000000087	SAFE-OPS	Safe Operations	hybrid	2025-03-22 11:38:31.466569+00	84	2025-03-22 11:38:31.466569+00
d3000001-0000-4000-8000-00000000020e	d1000001-0000-4000-8000-000000000088	LIFT-101	Lift 101	online	2025-03-20 11:38:31.466569+00	87	2025-03-20 11:38:31.466569+00
d3000001-0000-4000-8000-00000000020f	d1000001-0000-4000-8000-000000000089	FORK-201	Forklift 201	in_person	2025-03-18 11:38:31.466569+00	90	2025-03-18 11:38:31.466569+00
d3000001-0000-4000-8000-000000000210	d1000001-0000-4000-8000-00000000008a	REACH-101	Reach 101	hybrid	2025-03-16 11:38:31.466569+00	93	2025-03-16 11:38:31.466569+00
d3000001-0000-4000-8000-000000000211	d1000001-0000-4000-8000-00000000008b	SAFE-OPS	Safe Operations	online	2025-03-14 11:38:31.466569+00	96	2025-03-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000212	d1000001-0000-4000-8000-00000000008c	LIFT-101	Lift 101	in_person	2025-03-12 11:38:31.466569+00	71	2025-03-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000213	d1000001-0000-4000-8000-00000000008d	FORK-201	Forklift 201	hybrid	2025-03-10 11:38:31.466569+00	74	2025-03-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000214	d1000001-0000-4000-8000-00000000008e	REACH-101	Reach 101	online	2025-03-08 11:38:31.466569+00	77	2025-03-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000215	d1000001-0000-4000-8000-00000000008f	SAFE-OPS	Safe Operations	in_person	2025-03-06 11:38:31.466569+00	80	2025-03-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000216	d1000001-0000-4000-8000-000000000090	LIFT-101	Lift 101	hybrid	2025-03-04 11:38:31.466569+00	83	2025-03-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000217	d1000001-0000-4000-8000-000000000091	FORK-201	Forklift 201	online	2025-03-02 11:38:31.466569+00	86	2025-03-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000218	d1000001-0000-4000-8000-000000000092	REACH-101	Reach 101	in_person	2025-02-28 11:38:31.466569+00	89	2025-02-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000219	d1000001-0000-4000-8000-000000000093	SAFE-OPS	Safe Operations	hybrid	2025-02-26 11:38:31.466569+00	92	2025-02-26 11:38:31.466569+00
d3000001-0000-4000-8000-00000000021a	d1000001-0000-4000-8000-000000000094	LIFT-101	Lift 101	online	2026-02-24 11:38:31.466569+00	95	2026-02-24 11:38:31.466569+00
d3000001-0000-4000-8000-00000000021b	d1000001-0000-4000-8000-000000000095	FORK-201	Forklift 201	in_person	2026-02-22 11:38:31.466569+00	70	2026-02-22 11:38:31.466569+00
d3000001-0000-4000-8000-00000000021c	d1000001-0000-4000-8000-000000000096	REACH-101	Reach 101	hybrid	2026-02-20 11:38:31.466569+00	73	2026-02-20 11:38:31.466569+00
d3000001-0000-4000-8000-00000000021d	d1000001-0000-4000-8000-000000000097	SAFE-OPS	Safe Operations	online	2026-02-18 11:38:31.466569+00	76	2026-02-18 11:38:31.466569+00
d3000001-0000-4000-8000-00000000021e	d1000001-0000-4000-8000-000000000098	LIFT-101	Lift 101	in_person	2026-02-16 11:38:31.466569+00	79	2026-02-16 11:38:31.466569+00
d3000001-0000-4000-8000-00000000021f	d1000001-0000-4000-8000-000000000099	FORK-201	Forklift 201	hybrid	2026-02-14 11:38:31.466569+00	82	2026-02-14 11:38:31.466569+00
d3000001-0000-4000-8000-000000000220	d1000001-0000-4000-8000-00000000009a	REACH-101	Reach 101	online	2026-02-12 11:38:31.466569+00	85	2026-02-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000221	d1000001-0000-4000-8000-00000000009b	SAFE-OPS	Safe Operations	in_person	2026-02-10 11:38:31.466569+00	88	2026-02-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000222	d1000001-0000-4000-8000-00000000009c	LIFT-101	Lift 101	hybrid	2026-02-08 11:38:31.466569+00	91	2026-02-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000223	d1000001-0000-4000-8000-00000000009d	FORK-201	Forklift 201	online	2026-02-06 11:38:31.466569+00	94	2026-02-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000224	d1000001-0000-4000-8000-00000000009e	REACH-101	Reach 101	in_person	2026-02-04 11:38:31.466569+00	97	2026-02-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000225	d1000001-0000-4000-8000-00000000009f	SAFE-OPS	Safe Operations	hybrid	2026-02-02 11:38:31.466569+00	72	2026-02-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000226	d1000001-0000-4000-8000-0000000000a0	LIFT-101	Lift 101	online	2026-01-31 11:38:31.466569+00	75	2026-01-31 11:38:31.466569+00
d3000001-0000-4000-8000-000000000227	d1000001-0000-4000-8000-0000000000a1	FORK-201	Forklift 201	in_person	2026-01-29 11:38:31.466569+00	78	2026-01-29 11:38:31.466569+00
d3000001-0000-4000-8000-000000000228	d1000001-0000-4000-8000-0000000000a2	REACH-101	Reach 101	hybrid	2026-01-27 11:38:31.466569+00	81	2026-01-27 11:38:31.466569+00
d3000001-0000-4000-8000-000000000229	d1000001-0000-4000-8000-0000000000a3	SAFE-OPS	Safe Operations	online	2026-01-25 11:38:31.466569+00	84	2026-01-25 11:38:31.466569+00
d3000001-0000-4000-8000-00000000022a	d1000001-0000-4000-8000-0000000000a4	LIFT-101	Lift 101	in_person	2026-01-23 11:38:31.466569+00	87	2026-01-23 11:38:31.466569+00
d3000001-0000-4000-8000-00000000022b	d1000001-0000-4000-8000-0000000000a5	FORK-201	Forklift 201	hybrid	2026-01-21 11:38:31.466569+00	90	2026-01-21 11:38:31.466569+00
d3000001-0000-4000-8000-00000000022c	d1000001-0000-4000-8000-0000000000a6	REACH-101	Reach 101	online	2026-01-19 11:38:31.466569+00	93	2026-01-19 11:38:31.466569+00
d3000001-0000-4000-8000-00000000022d	d1000001-0000-4000-8000-0000000000a7	SAFE-OPS	Safe Operations	in_person	2026-01-17 11:38:31.466569+00	96	2026-01-17 11:38:31.466569+00
d3000001-0000-4000-8000-00000000022e	d1000001-0000-4000-8000-0000000000a8	LIFT-101	Lift 101	hybrid	2026-01-15 11:38:31.466569+00	71	2026-01-15 11:38:31.466569+00
d3000001-0000-4000-8000-00000000022f	d1000001-0000-4000-8000-0000000000a9	FORK-201	Forklift 201	online	2026-01-13 11:38:31.466569+00	74	2026-01-13 11:38:31.466569+00
d3000001-0000-4000-8000-000000000230	d1000001-0000-4000-8000-0000000000aa	REACH-101	Reach 101	in_person	2026-01-11 11:38:31.466569+00	77	2026-01-11 11:38:31.466569+00
d3000001-0000-4000-8000-000000000231	d1000001-0000-4000-8000-0000000000ab	SAFE-OPS	Safe Operations	hybrid	2026-01-09 11:38:31.466569+00	80	2026-01-09 11:38:31.466569+00
d3000001-0000-4000-8000-000000000232	d1000001-0000-4000-8000-0000000000ac	LIFT-101	Lift 101	online	2026-01-07 11:38:31.466569+00	83	2026-01-07 11:38:31.466569+00
d3000001-0000-4000-8000-000000000233	d1000001-0000-4000-8000-0000000000ad	FORK-201	Forklift 201	in_person	2026-01-05 11:38:31.466569+00	86	2026-01-05 11:38:31.466569+00
d3000001-0000-4000-8000-000000000234	d1000001-0000-4000-8000-0000000000ae	REACH-101	Reach 101	hybrid	2026-01-03 11:38:31.466569+00	89	2026-01-03 11:38:31.466569+00
d3000001-0000-4000-8000-000000000235	d1000001-0000-4000-8000-0000000000af	SAFE-OPS	Safe Operations	online	2026-01-01 11:38:31.466569+00	92	2026-01-01 11:38:31.466569+00
d3000001-0000-4000-8000-000000000236	d1000001-0000-4000-8000-0000000000b0	LIFT-101	Lift 101	in_person	2025-12-30 11:38:31.466569+00	95	2025-12-30 11:38:31.466569+00
d3000001-0000-4000-8000-000000000237	d1000001-0000-4000-8000-0000000000b1	FORK-201	Forklift 201	hybrid	2025-12-28 11:38:31.466569+00	70	2025-12-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000238	d1000001-0000-4000-8000-0000000000b2	REACH-101	Reach 101	online	2025-12-26 11:38:31.466569+00	73	2025-12-26 11:38:31.466569+00
d3000001-0000-4000-8000-000000000239	d1000001-0000-4000-8000-0000000000b3	SAFE-OPS	Safe Operations	in_person	2025-12-24 11:38:31.466569+00	76	2025-12-24 11:38:31.466569+00
d3000001-0000-4000-8000-00000000023a	d1000001-0000-4000-8000-0000000000b4	LIFT-101	Lift 101	hybrid	2025-12-22 11:38:31.466569+00	79	2025-12-22 11:38:31.466569+00
d3000001-0000-4000-8000-00000000023b	d1000001-0000-4000-8000-0000000000b5	FORK-201	Forklift 201	online	2025-12-20 11:38:31.466569+00	82	2025-12-20 11:38:31.466569+00
d3000001-0000-4000-8000-00000000023c	d1000001-0000-4000-8000-0000000000b6	REACH-101	Reach 101	in_person	2025-12-18 11:38:31.466569+00	85	2025-12-18 11:38:31.466569+00
d3000001-0000-4000-8000-00000000023d	d1000001-0000-4000-8000-0000000000b7	SAFE-OPS	Safe Operations	hybrid	2025-12-16 11:38:31.466569+00	88	2025-12-16 11:38:31.466569+00
d3000001-0000-4000-8000-00000000023e	d1000001-0000-4000-8000-0000000000b8	LIFT-101	Lift 101	online	2025-12-14 11:38:31.466569+00	91	2025-12-14 11:38:31.466569+00
d3000001-0000-4000-8000-00000000023f	d1000001-0000-4000-8000-0000000000b9	FORK-201	Forklift 201	in_person	2025-12-12 11:38:31.466569+00	94	2025-12-12 11:38:31.466569+00
d3000001-0000-4000-8000-000000000240	d1000001-0000-4000-8000-0000000000ba	REACH-101	Reach 101	hybrid	2025-12-10 11:38:31.466569+00	97	2025-12-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000241	d1000001-0000-4000-8000-0000000000bb	SAFE-OPS	Safe Operations	online	2025-12-08 11:38:31.466569+00	72	2025-12-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000242	d1000001-0000-4000-8000-0000000000bc	LIFT-101	Lift 101	in_person	2025-12-06 11:38:31.466569+00	75	2025-12-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000243	d1000001-0000-4000-8000-0000000000bd	FORK-201	Forklift 201	hybrid	2025-12-04 11:38:31.466569+00	78	2025-12-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000244	d1000001-0000-4000-8000-0000000000be	REACH-101	Reach 101	online	2025-12-02 11:38:31.466569+00	81	2025-12-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000245	d1000001-0000-4000-8000-0000000000bf	SAFE-OPS	Safe Operations	in_person	2025-11-30 11:38:31.466569+00	84	2025-11-30 11:38:31.466569+00
d3000001-0000-4000-8000-000000000246	d1000001-0000-4000-8000-0000000000c0	LIFT-101	Lift 101	hybrid	2025-11-28 11:38:31.466569+00	87	2025-11-28 11:38:31.466569+00
d3000001-0000-4000-8000-000000000247	d1000001-0000-4000-8000-0000000000c1	FORK-201	Forklift 201	online	2025-11-26 11:38:31.466569+00	90	2025-11-26 11:38:31.466569+00
d3000001-0000-4000-8000-000000000248	d1000001-0000-4000-8000-0000000000c2	REACH-101	Reach 101	in_person	2025-11-24 11:38:31.466569+00	93	2025-11-24 11:38:31.466569+00
d3000001-0000-4000-8000-000000000249	d1000001-0000-4000-8000-0000000000c3	SAFE-OPS	Safe Operations	hybrid	2025-11-22 11:38:31.466569+00	96	2025-11-22 11:38:31.466569+00
d3000001-0000-4000-8000-00000000024a	d1000001-0000-4000-8000-0000000000c4	LIFT-101	Lift 101	online	2025-11-20 11:38:31.466569+00	71	2025-11-20 11:38:31.466569+00
d3000001-0000-4000-8000-00000000024b	d1000001-0000-4000-8000-0000000000c5	FORK-201	Forklift 201	in_person	2025-11-18 11:38:31.466569+00	74	2025-11-18 11:38:31.466569+00
d3000001-0000-4000-8000-00000000024c	d1000001-0000-4000-8000-0000000000c6	REACH-101	Reach 101	hybrid	2025-11-16 11:38:31.466569+00	77	2025-11-16 11:38:31.466569+00
d3000001-0000-4000-8000-00000000024d	d1000001-0000-4000-8000-0000000000c7	SAFE-OPS	Safe Operations	online	2025-11-14 11:38:31.466569+00	80	2025-11-14 11:38:31.466569+00
d3000001-0000-4000-8000-00000000024e	d1000001-0000-4000-8000-0000000000c8	LIFT-101	Lift 101	in_person	2025-11-12 11:38:31.466569+00	83	2025-11-12 11:38:31.466569+00
d3000001-0000-4000-8000-00000000024f	d1000001-0000-4000-8000-0000000000c9	FORK-201	Forklift 201	hybrid	2025-11-10 11:38:31.466569+00	86	2025-11-10 11:38:31.466569+00
d3000001-0000-4000-8000-000000000250	d1000001-0000-4000-8000-0000000000ca	REACH-101	Reach 101	online	2025-11-08 11:38:31.466569+00	89	2025-11-08 11:38:31.466569+00
d3000001-0000-4000-8000-000000000251	d1000001-0000-4000-8000-0000000000cb	SAFE-OPS	Safe Operations	in_person	2025-11-06 11:38:31.466569+00	92	2025-11-06 11:38:31.466569+00
d3000001-0000-4000-8000-000000000252	d1000001-0000-4000-8000-0000000000cc	LIFT-101	Lift 101	hybrid	2025-11-04 11:38:31.466569+00	95	2025-11-04 11:38:31.466569+00
d3000001-0000-4000-8000-000000000253	d1000001-0000-4000-8000-0000000000cd	FORK-201	Forklift 201	online	2025-11-02 11:38:31.466569+00	70	2025-11-02 11:38:31.466569+00
d3000001-0000-4000-8000-000000000254	d1000001-0000-4000-8000-0000000000ce	REACH-101	Reach 101	in_person	2025-10-31 11:38:31.466569+00	73	2025-10-31 11:38:31.466569+00
d3000001-0000-4000-8000-000000000255	d1000001-0000-4000-8000-0000000000cf	SAFE-OPS	Safe Operations	hybrid	2025-10-29 11:38:31.466569+00	76	2025-10-29 11:38:31.466569+00
d3000001-0000-4000-8000-000000000256	d1000001-0000-4000-8000-0000000000d0	LIFT-101	Lift 101	online	2025-10-27 11:38:31.466569+00	79	2025-10-27 11:38:31.466569+00
d3000001-0000-4000-8000-000000000257	d1000001-0000-4000-8000-0000000000d1	FORK-201	Forklift 201	in_person	2025-10-25 11:38:31.466569+00	82	2025-10-25 11:38:31.466569+00
d3000001-0000-4000-8000-000000000258	d1000001-0000-4000-8000-0000000000d2	REACH-101	Reach 101	hybrid	2025-10-23 11:38:31.466569+00	85	2025-10-23 11:38:31.466569+00
\.


--
-- Data for Name: linkedin_profiles; Type: TABLE DATA; Schema: demo; Owner: apiary
--

COPY demo.linkedin_profiles (id, person_id, linkedin_id, headline, connections_count, last_synced_at, created_at) FROM stdin;
a7bc2367-12c8-4c50-a3af-62f55411a30f	d1000001-0000-4000-8000-000000000001	li_demo_d1000001000040008000000000000001	Operations Lead at Demo	497	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
4e8144f8-fe4f-4c8a-821b-f7df000ad8cf	d1000001-0000-4000-8000-000000000002	li_demo_d1000001000040008000000000000002	Operations Lead at Demo	644	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
d9cc50fe-1c52-47dc-835d-dd831f919087	d1000001-0000-4000-8000-000000000003	li_demo_d1000001000040008000000000000003	Operations Lead at Demo	558	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
e40b97a6-13f1-4328-aa86-282ef0d0b12f	d1000001-0000-4000-8000-000000000004	li_demo_d1000001000040008000000000000004	Operations Lead at Demo	504	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
9d6d8e13-0c3f-4eb0-a433-25c258bc0709	d1000001-0000-4000-8000-000000000005	li_demo_d1000001000040008000000000000005	Operations Lead at Demo	444	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
78006f51-a130-4fbc-bc40-59689b569fb0	d1000001-0000-4000-8000-000000000006	li_demo_d1000001000040008000000000000006	Operations Lead at Demo	434	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
cd7c66da-1806-4c95-87e9-c1146ae87f40	d1000001-0000-4000-8000-000000000007	li_demo_d1000001000040008000000000000007	Operations Lead at Demo	934	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
9c273837-0799-4da1-bef6-7dffa5230376	d1000001-0000-4000-8000-000000000008	li_demo_d1000001000040008000000000000008	Operations Lead at Demo	221	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
97a930ac-956f-4d51-b281-3455903c9beb	d1000001-0000-4000-8000-000000000009	li_demo_d1000001000040008000000000000009	Operations Lead at Demo	966	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
2f439d72-8649-41d6-b051-2e5d04373646	d1000001-0000-4000-8000-00000000000a	li_demo_d100000100004000800000000000000a	Operations Lead at Demo	291	2026-02-25 11:38:31.421048+00	2026-02-25 11:38:31.421048+00
d3000004-0000-4000-8000-00000000000b	d1000001-0000-4000-8000-00000000000b	li_bulk_11	Professional at Demo 11	107	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000000c	d1000001-0000-4000-8000-00000000000c	li_bulk_12	Professional at Demo 12	114	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000000d	d1000001-0000-4000-8000-00000000000d	li_bulk_13	Professional at Demo 13	121	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000000e	d1000001-0000-4000-8000-00000000000e	li_bulk_14	Professional at Demo 14	128	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000000f	d1000001-0000-4000-8000-00000000000f	li_bulk_15	Professional at Demo 15	135	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000010	d1000001-0000-4000-8000-000000000010	li_bulk_16	Professional at Demo 16	142	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000011	d1000001-0000-4000-8000-000000000011	li_bulk_17	Professional at Demo 17	149	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000012	d1000001-0000-4000-8000-000000000012	li_bulk_18	Professional at Demo 18	156	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000013	d1000001-0000-4000-8000-000000000013	li_bulk_19	Professional at Demo 19	163	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000014	d1000001-0000-4000-8000-000000000014	li_bulk_20	Professional at Demo 20	170	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000015	d1000001-0000-4000-8000-000000000015	li_bulk_21	Professional at Demo 21	177	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000016	d1000001-0000-4000-8000-000000000016	li_bulk_22	Professional at Demo 22	184	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000017	d1000001-0000-4000-8000-000000000017	li_bulk_23	Professional at Demo 23	191	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000018	d1000001-0000-4000-8000-000000000018	li_bulk_24	Professional at Demo 24	198	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000019	d1000001-0000-4000-8000-000000000019	li_bulk_25	Professional at Demo 25	205	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000001a	d1000001-0000-4000-8000-00000000001a	li_bulk_26	Professional at Demo 26	212	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000001b	d1000001-0000-4000-8000-00000000001b	li_bulk_27	Professional at Demo 27	219	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000001c	d1000001-0000-4000-8000-00000000001c	li_bulk_28	Professional at Demo 28	226	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000001d	d1000001-0000-4000-8000-00000000001d	li_bulk_29	Professional at Demo 29	233	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000001e	d1000001-0000-4000-8000-00000000001e	li_bulk_30	Professional at Demo 30	240	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000001f	d1000001-0000-4000-8000-00000000001f	li_bulk_31	Professional at Demo 31	247	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000020	d1000001-0000-4000-8000-000000000020	li_bulk_32	Professional at Demo 32	254	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000021	d1000001-0000-4000-8000-000000000021	li_bulk_33	Professional at Demo 33	261	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000022	d1000001-0000-4000-8000-000000000022	li_bulk_34	Professional at Demo 34	268	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000023	d1000001-0000-4000-8000-000000000023	li_bulk_35	Professional at Demo 35	275	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000024	d1000001-0000-4000-8000-000000000024	li_bulk_36	Professional at Demo 36	282	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000025	d1000001-0000-4000-8000-000000000025	li_bulk_37	Professional at Demo 37	289	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000026	d1000001-0000-4000-8000-000000000026	li_bulk_38	Professional at Demo 38	296	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000027	d1000001-0000-4000-8000-000000000027	li_bulk_39	Professional at Demo 39	303	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000028	d1000001-0000-4000-8000-000000000028	li_bulk_40	Professional at Demo 40	310	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000029	d1000001-0000-4000-8000-000000000029	li_bulk_41	Professional at Demo 41	317	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000002a	d1000001-0000-4000-8000-00000000002a	li_bulk_42	Professional at Demo 42	324	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000002b	d1000001-0000-4000-8000-00000000002b	li_bulk_43	Professional at Demo 43	331	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000002c	d1000001-0000-4000-8000-00000000002c	li_bulk_44	Professional at Demo 44	338	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000002d	d1000001-0000-4000-8000-00000000002d	li_bulk_45	Professional at Demo 45	345	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000002e	d1000001-0000-4000-8000-00000000002e	li_bulk_46	Professional at Demo 46	352	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000002f	d1000001-0000-4000-8000-00000000002f	li_bulk_47	Professional at Demo 47	359	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000030	d1000001-0000-4000-8000-000000000030	li_bulk_48	Professional at Demo 48	366	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000031	d1000001-0000-4000-8000-000000000031	li_bulk_49	Professional at Demo 49	373	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000032	d1000001-0000-4000-8000-000000000032	li_bulk_50	Professional at Demo 50	380	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000033	d1000001-0000-4000-8000-000000000033	li_bulk_51	Professional at Demo 51	387	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000034	d1000001-0000-4000-8000-000000000034	li_bulk_52	Professional at Demo 52	394	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000035	d1000001-0000-4000-8000-000000000035	li_bulk_53	Professional at Demo 53	401	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000036	d1000001-0000-4000-8000-000000000036	li_bulk_54	Professional at Demo 54	408	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000037	d1000001-0000-4000-8000-000000000037	li_bulk_55	Professional at Demo 55	415	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000038	d1000001-0000-4000-8000-000000000038	li_bulk_56	Professional at Demo 56	422	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000039	d1000001-0000-4000-8000-000000000039	li_bulk_57	Professional at Demo 57	429	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000003a	d1000001-0000-4000-8000-00000000003a	li_bulk_58	Professional at Demo 58	436	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000003b	d1000001-0000-4000-8000-00000000003b	li_bulk_59	Professional at Demo 59	443	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000003c	d1000001-0000-4000-8000-00000000003c	li_bulk_60	Professional at Demo 60	450	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000003d	d1000001-0000-4000-8000-00000000003d	li_bulk_61	Professional at Demo 61	457	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000003e	d1000001-0000-4000-8000-00000000003e	li_bulk_62	Professional at Demo 62	464	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000003f	d1000001-0000-4000-8000-00000000003f	li_bulk_63	Professional at Demo 63	471	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000040	d1000001-0000-4000-8000-000000000040	li_bulk_64	Professional at Demo 64	478	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000041	d1000001-0000-4000-8000-000000000041	li_bulk_65	Professional at Demo 65	485	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000042	d1000001-0000-4000-8000-000000000042	li_bulk_66	Professional at Demo 66	492	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000043	d1000001-0000-4000-8000-000000000043	li_bulk_67	Professional at Demo 67	499	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000044	d1000001-0000-4000-8000-000000000044	li_bulk_68	Professional at Demo 68	506	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000045	d1000001-0000-4000-8000-000000000045	li_bulk_69	Professional at Demo 69	513	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000046	d1000001-0000-4000-8000-000000000046	li_bulk_70	Professional at Demo 70	520	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000047	d1000001-0000-4000-8000-000000000047	li_bulk_71	Professional at Demo 71	527	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000048	d1000001-0000-4000-8000-000000000048	li_bulk_72	Professional at Demo 72	534	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000049	d1000001-0000-4000-8000-000000000049	li_bulk_73	Professional at Demo 73	541	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000004a	d1000001-0000-4000-8000-00000000004a	li_bulk_74	Professional at Demo 74	548	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000004b	d1000001-0000-4000-8000-00000000004b	li_bulk_75	Professional at Demo 75	555	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000004c	d1000001-0000-4000-8000-00000000004c	li_bulk_76	Professional at Demo 76	562	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000004d	d1000001-0000-4000-8000-00000000004d	li_bulk_77	Professional at Demo 77	569	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000004e	d1000001-0000-4000-8000-00000000004e	li_bulk_78	Professional at Demo 78	576	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000004f	d1000001-0000-4000-8000-00000000004f	li_bulk_79	Professional at Demo 79	583	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000050	d1000001-0000-4000-8000-000000000050	li_bulk_80	Professional at Demo 80	590	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000051	d1000001-0000-4000-8000-000000000051	li_bulk_81	Professional at Demo 81	597	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000052	d1000001-0000-4000-8000-000000000052	li_bulk_82	Professional at Demo 82	604	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000053	d1000001-0000-4000-8000-000000000053	li_bulk_83	Professional at Demo 83	611	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000054	d1000001-0000-4000-8000-000000000054	li_bulk_84	Professional at Demo 84	618	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000055	d1000001-0000-4000-8000-000000000055	li_bulk_85	Professional at Demo 85	625	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000056	d1000001-0000-4000-8000-000000000056	li_bulk_86	Professional at Demo 86	632	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000057	d1000001-0000-4000-8000-000000000057	li_bulk_87	Professional at Demo 87	639	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000058	d1000001-0000-4000-8000-000000000058	li_bulk_88	Professional at Demo 88	646	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000059	d1000001-0000-4000-8000-000000000059	li_bulk_89	Professional at Demo 89	653	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000005a	d1000001-0000-4000-8000-00000000005a	li_bulk_90	Professional at Demo 90	660	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000005b	d1000001-0000-4000-8000-00000000005b	li_bulk_91	Professional at Demo 91	667	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000005c	d1000001-0000-4000-8000-00000000005c	li_bulk_92	Professional at Demo 92	674	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000005d	d1000001-0000-4000-8000-00000000005d	li_bulk_93	Professional at Demo 93	681	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000005e	d1000001-0000-4000-8000-00000000005e	li_bulk_94	Professional at Demo 94	688	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000005f	d1000001-0000-4000-8000-00000000005f	li_bulk_95	Professional at Demo 95	695	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000060	d1000001-0000-4000-8000-000000000060	li_bulk_96	Professional at Demo 96	702	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000061	d1000001-0000-4000-8000-000000000061	li_bulk_97	Professional at Demo 97	709	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000062	d1000001-0000-4000-8000-000000000062	li_bulk_98	Professional at Demo 98	716	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000063	d1000001-0000-4000-8000-000000000063	li_bulk_99	Professional at Demo 99	723	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000064	d1000001-0000-4000-8000-000000000064	li_bulk_100	Professional at Demo 100	730	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000065	d1000001-0000-4000-8000-000000000065	li_bulk_101	Professional at Demo 101	737	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000066	d1000001-0000-4000-8000-000000000066	li_bulk_102	Professional at Demo 102	744	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000067	d1000001-0000-4000-8000-000000000067	li_bulk_103	Professional at Demo 103	751	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000068	d1000001-0000-4000-8000-000000000068	li_bulk_104	Professional at Demo 104	758	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000069	d1000001-0000-4000-8000-000000000069	li_bulk_105	Professional at Demo 105	765	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000006a	d1000001-0000-4000-8000-00000000006a	li_bulk_106	Professional at Demo 106	772	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000006b	d1000001-0000-4000-8000-00000000006b	li_bulk_107	Professional at Demo 107	779	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000006c	d1000001-0000-4000-8000-00000000006c	li_bulk_108	Professional at Demo 108	786	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000006d	d1000001-0000-4000-8000-00000000006d	li_bulk_109	Professional at Demo 109	793	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000006e	d1000001-0000-4000-8000-00000000006e	li_bulk_110	Professional at Demo 110	800	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000006f	d1000001-0000-4000-8000-00000000006f	li_bulk_111	Professional at Demo 111	807	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000070	d1000001-0000-4000-8000-000000000070	li_bulk_112	Professional at Demo 112	814	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000071	d1000001-0000-4000-8000-000000000071	li_bulk_113	Professional at Demo 113	821	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000072	d1000001-0000-4000-8000-000000000072	li_bulk_114	Professional at Demo 114	828	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000073	d1000001-0000-4000-8000-000000000073	li_bulk_115	Professional at Demo 115	835	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000074	d1000001-0000-4000-8000-000000000074	li_bulk_116	Professional at Demo 116	842	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000075	d1000001-0000-4000-8000-000000000075	li_bulk_117	Professional at Demo 117	849	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000076	d1000001-0000-4000-8000-000000000076	li_bulk_118	Professional at Demo 118	856	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000077	d1000001-0000-4000-8000-000000000077	li_bulk_119	Professional at Demo 119	863	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000078	d1000001-0000-4000-8000-000000000078	li_bulk_120	Professional at Demo 120	870	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000079	d1000001-0000-4000-8000-000000000079	li_bulk_121	Professional at Demo 121	877	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000007a	d1000001-0000-4000-8000-00000000007a	li_bulk_122	Professional at Demo 122	884	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000007b	d1000001-0000-4000-8000-00000000007b	li_bulk_123	Professional at Demo 123	891	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000007c	d1000001-0000-4000-8000-00000000007c	li_bulk_124	Professional at Demo 124	898	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000007d	d1000001-0000-4000-8000-00000000007d	li_bulk_125	Professional at Demo 125	905	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000007e	d1000001-0000-4000-8000-00000000007e	li_bulk_126	Professional at Demo 126	912	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000007f	d1000001-0000-4000-8000-00000000007f	li_bulk_127	Professional at Demo 127	919	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000080	d1000001-0000-4000-8000-000000000080	li_bulk_128	Professional at Demo 128	926	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000081	d1000001-0000-4000-8000-000000000081	li_bulk_129	Professional at Demo 129	933	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000082	d1000001-0000-4000-8000-000000000082	li_bulk_130	Professional at Demo 130	940	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000083	d1000001-0000-4000-8000-000000000083	li_bulk_131	Professional at Demo 131	947	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000084	d1000001-0000-4000-8000-000000000084	li_bulk_132	Professional at Demo 132	954	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000085	d1000001-0000-4000-8000-000000000085	li_bulk_133	Professional at Demo 133	961	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000086	d1000001-0000-4000-8000-000000000086	li_bulk_134	Professional at Demo 134	968	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000087	d1000001-0000-4000-8000-000000000087	li_bulk_135	Professional at Demo 135	975	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000088	d1000001-0000-4000-8000-000000000088	li_bulk_136	Professional at Demo 136	982	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000089	d1000001-0000-4000-8000-000000000089	li_bulk_137	Professional at Demo 137	989	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000008a	d1000001-0000-4000-8000-00000000008a	li_bulk_138	Professional at Demo 138	996	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000008b	d1000001-0000-4000-8000-00000000008b	li_bulk_139	Professional at Demo 139	103	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000008c	d1000001-0000-4000-8000-00000000008c	li_bulk_140	Professional at Demo 140	110	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000008d	d1000001-0000-4000-8000-00000000008d	li_bulk_141	Professional at Demo 141	117	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000008e	d1000001-0000-4000-8000-00000000008e	li_bulk_142	Professional at Demo 142	124	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000008f	d1000001-0000-4000-8000-00000000008f	li_bulk_143	Professional at Demo 143	131	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000090	d1000001-0000-4000-8000-000000000090	li_bulk_144	Professional at Demo 144	138	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000091	d1000001-0000-4000-8000-000000000091	li_bulk_145	Professional at Demo 145	145	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000092	d1000001-0000-4000-8000-000000000092	li_bulk_146	Professional at Demo 146	152	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000093	d1000001-0000-4000-8000-000000000093	li_bulk_147	Professional at Demo 147	159	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000094	d1000001-0000-4000-8000-000000000094	li_bulk_148	Professional at Demo 148	166	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000095	d1000001-0000-4000-8000-000000000095	li_bulk_149	Professional at Demo 149	173	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000096	d1000001-0000-4000-8000-000000000096	li_bulk_150	Professional at Demo 150	180	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000097	d1000001-0000-4000-8000-000000000097	li_bulk_151	Professional at Demo 151	187	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000098	d1000001-0000-4000-8000-000000000098	li_bulk_152	Professional at Demo 152	194	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-000000000099	d1000001-0000-4000-8000-000000000099	li_bulk_153	Professional at Demo 153	201	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000009a	d1000001-0000-4000-8000-00000000009a	li_bulk_154	Professional at Demo 154	208	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000009b	d1000001-0000-4000-8000-00000000009b	li_bulk_155	Professional at Demo 155	215	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000009c	d1000001-0000-4000-8000-00000000009c	li_bulk_156	Professional at Demo 156	222	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000009d	d1000001-0000-4000-8000-00000000009d	li_bulk_157	Professional at Demo 157	229	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000009e	d1000001-0000-4000-8000-00000000009e	li_bulk_158	Professional at Demo 158	236	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-00000000009f	d1000001-0000-4000-8000-00000000009f	li_bulk_159	Professional at Demo 159	243	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a0	d1000001-0000-4000-8000-0000000000a0	li_bulk_160	Professional at Demo 160	250	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a1	d1000001-0000-4000-8000-0000000000a1	li_bulk_161	Professional at Demo 161	257	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a2	d1000001-0000-4000-8000-0000000000a2	li_bulk_162	Professional at Demo 162	264	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a3	d1000001-0000-4000-8000-0000000000a3	li_bulk_163	Professional at Demo 163	271	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a4	d1000001-0000-4000-8000-0000000000a4	li_bulk_164	Professional at Demo 164	278	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a5	d1000001-0000-4000-8000-0000000000a5	li_bulk_165	Professional at Demo 165	285	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a6	d1000001-0000-4000-8000-0000000000a6	li_bulk_166	Professional at Demo 166	292	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a7	d1000001-0000-4000-8000-0000000000a7	li_bulk_167	Professional at Demo 167	299	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a8	d1000001-0000-4000-8000-0000000000a8	li_bulk_168	Professional at Demo 168	306	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000a9	d1000001-0000-4000-8000-0000000000a9	li_bulk_169	Professional at Demo 169	313	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000aa	d1000001-0000-4000-8000-0000000000aa	li_bulk_170	Professional at Demo 170	320	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000ab	d1000001-0000-4000-8000-0000000000ab	li_bulk_171	Professional at Demo 171	327	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000ac	d1000001-0000-4000-8000-0000000000ac	li_bulk_172	Professional at Demo 172	334	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000ad	d1000001-0000-4000-8000-0000000000ad	li_bulk_173	Professional at Demo 173	341	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000ae	d1000001-0000-4000-8000-0000000000ae	li_bulk_174	Professional at Demo 174	348	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000af	d1000001-0000-4000-8000-0000000000af	li_bulk_175	Professional at Demo 175	355	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b0	d1000001-0000-4000-8000-0000000000b0	li_bulk_176	Professional at Demo 176	362	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b1	d1000001-0000-4000-8000-0000000000b1	li_bulk_177	Professional at Demo 177	369	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b2	d1000001-0000-4000-8000-0000000000b2	li_bulk_178	Professional at Demo 178	376	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b3	d1000001-0000-4000-8000-0000000000b3	li_bulk_179	Professional at Demo 179	383	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b4	d1000001-0000-4000-8000-0000000000b4	li_bulk_180	Professional at Demo 180	390	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b5	d1000001-0000-4000-8000-0000000000b5	li_bulk_181	Professional at Demo 181	397	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b6	d1000001-0000-4000-8000-0000000000b6	li_bulk_182	Professional at Demo 182	404	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b7	d1000001-0000-4000-8000-0000000000b7	li_bulk_183	Professional at Demo 183	411	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b8	d1000001-0000-4000-8000-0000000000b8	li_bulk_184	Professional at Demo 184	418	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000b9	d1000001-0000-4000-8000-0000000000b9	li_bulk_185	Professional at Demo 185	425	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000ba	d1000001-0000-4000-8000-0000000000ba	li_bulk_186	Professional at Demo 186	432	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000bb	d1000001-0000-4000-8000-0000000000bb	li_bulk_187	Professional at Demo 187	439	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000bc	d1000001-0000-4000-8000-0000000000bc	li_bulk_188	Professional at Demo 188	446	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000bd	d1000001-0000-4000-8000-0000000000bd	li_bulk_189	Professional at Demo 189	453	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000be	d1000001-0000-4000-8000-0000000000be	li_bulk_190	Professional at Demo 190	460	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000bf	d1000001-0000-4000-8000-0000000000bf	li_bulk_191	Professional at Demo 191	467	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c0	d1000001-0000-4000-8000-0000000000c0	li_bulk_192	Professional at Demo 192	474	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c1	d1000001-0000-4000-8000-0000000000c1	li_bulk_193	Professional at Demo 193	481	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c2	d1000001-0000-4000-8000-0000000000c2	li_bulk_194	Professional at Demo 194	488	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c3	d1000001-0000-4000-8000-0000000000c3	li_bulk_195	Professional at Demo 195	495	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c4	d1000001-0000-4000-8000-0000000000c4	li_bulk_196	Professional at Demo 196	502	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c5	d1000001-0000-4000-8000-0000000000c5	li_bulk_197	Professional at Demo 197	509	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c6	d1000001-0000-4000-8000-0000000000c6	li_bulk_198	Professional at Demo 198	516	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c7	d1000001-0000-4000-8000-0000000000c7	li_bulk_199	Professional at Demo 199	523	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c8	d1000001-0000-4000-8000-0000000000c8	li_bulk_200	Professional at Demo 200	530	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000c9	d1000001-0000-4000-8000-0000000000c9	li_bulk_201	Professional at Demo 201	537	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000ca	d1000001-0000-4000-8000-0000000000ca	li_bulk_202	Professional at Demo 202	544	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000cb	d1000001-0000-4000-8000-0000000000cb	li_bulk_203	Professional at Demo 203	551	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000cc	d1000001-0000-4000-8000-0000000000cc	li_bulk_204	Professional at Demo 204	558	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000cd	d1000001-0000-4000-8000-0000000000cd	li_bulk_205	Professional at Demo 205	565	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000ce	d1000001-0000-4000-8000-0000000000ce	li_bulk_206	Professional at Demo 206	572	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000cf	d1000001-0000-4000-8000-0000000000cf	li_bulk_207	Professional at Demo 207	579	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000d0	d1000001-0000-4000-8000-0000000000d0	li_bulk_208	Professional at Demo 208	586	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000d1	d1000001-0000-4000-8000-0000000000d1	li_bulk_209	Professional at Demo 209	593	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
d3000004-0000-4000-8000-0000000000d2	d1000001-0000-4000-8000-0000000000d2	li_bulk_210	Professional at Demo 210	600	2026-02-25 11:38:31.512505+00	2026-02-25 11:38:31.512505+00
\.


--
-- Data for Name: salesforce_contacts; Type: TABLE DATA; Schema: demo; Owner: apiary
--

COPY demo.salesforce_contacts (id, person_id, salesforce_id, email, company_name, lead_source, created_at, updated_at) FROM stdin;
a4cf6ef9-b7f2-473d-84e6-0dfedd883f0d	d1000001-0000-4000-8000-000000000001	sf_d1000001000040008000000000000001	demo1@metabase-demo.example.com	Demo Corp 1	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
4fc10ff1-5f48-4c85-92fb-de21d8689cbd	d1000001-0000-4000-8000-000000000002	sf_d1000001000040008000000000000002	demo2@metabase-demo.example.com	Demo Corp 2	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
4bd75583-a08b-4edf-9c4b-997dc1c26c67	d1000001-0000-4000-8000-000000000003	sf_d1000001000040008000000000000003	demo3@metabase-demo.example.com	Demo Corp 3	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
501c94ba-ab31-45c6-83ad-871937c353f6	d1000001-0000-4000-8000-000000000004	sf_d1000001000040008000000000000004	demo4@metabase-demo.example.com	Demo Corp 4	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
d8523f4a-3a2b-428f-8ca1-c2890b054c08	d1000001-0000-4000-8000-000000000005	sf_d1000001000040008000000000000005	demo5@metabase-demo.example.com	Demo Corp 5	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
71c01c65-1205-4acd-bbeb-72423d0e7d99	d1000001-0000-4000-8000-000000000006	sf_d1000001000040008000000000000006	demo6@metabase-demo.example.com	Demo Corp 6	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
d1d9189d-cb29-413b-a895-5a0253f57778	d1000001-0000-4000-8000-000000000007	sf_d1000001000040008000000000000007	demo7@metabase-demo.example.com	Demo Corp 7	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
dab1b10c-9d9b-4420-884c-ad610bd53b56	d1000001-0000-4000-8000-000000000008	sf_d1000001000040008000000000000008	demo8@metabase-demo.example.com	Demo Corp 8	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
1f608696-3986-499a-821d-acf1670f0b3a	d1000001-0000-4000-8000-000000000009	sf_d1000001000040008000000000000009	demo9@metabase-demo.example.com	Demo Corp 9	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
d6135e7f-b9b9-49c2-90c5-cde0ea209823	d1000001-0000-4000-8000-00000000000a	sf_d100000100004000800000000000000a	demo10@metabase-demo.example.com	Demo Corp 1	Website	2026-02-25 11:38:31.414552+00	2026-02-25 11:38:31.414552+00
d3000002-0000-4000-8000-00000000000b	d1000001-0000-4000-8000-00000000000b	sf_bulk_11	demo11@metabase-demo.example.com	Demo Company 11	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000000c	d1000001-0000-4000-8000-00000000000c	sf_bulk_12	demo12@metabase-demo.example.com	Demo Company 12	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000000d	d1000001-0000-4000-8000-00000000000d	sf_bulk_13	demo13@metabase-demo.example.com	Demo Company 13	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000000e	d1000001-0000-4000-8000-00000000000e	sf_bulk_14	demo14@metabase-demo.example.com	Demo Company 14	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000000f	d1000001-0000-4000-8000-00000000000f	sf_bulk_15	demo15@metabase-demo.example.com	Demo Company 15	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000010	d1000001-0000-4000-8000-000000000010	sf_bulk_16	demo16@metabase-demo.example.com	Demo Company 16	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000011	d1000001-0000-4000-8000-000000000011	sf_bulk_17	demo17@metabase-demo.example.com	Demo Company 17	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000012	d1000001-0000-4000-8000-000000000012	sf_bulk_18	demo18@metabase-demo.example.com	Demo Company 18	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000013	d1000001-0000-4000-8000-000000000013	sf_bulk_19	demo19@metabase-demo.example.com	Demo Company 19	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000014	d1000001-0000-4000-8000-000000000014	sf_bulk_20	demo20@metabase-demo.example.com	Demo Company 20	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000015	d1000001-0000-4000-8000-000000000015	sf_bulk_21	demo21@metabase-demo.example.com	Demo Company 21	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000016	d1000001-0000-4000-8000-000000000016	sf_bulk_22	demo22@metabase-demo.example.com	Demo Company 22	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000017	d1000001-0000-4000-8000-000000000017	sf_bulk_23	demo23@metabase-demo.example.com	Demo Company 23	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000018	d1000001-0000-4000-8000-000000000018	sf_bulk_24	demo24@metabase-demo.example.com	Demo Company 24	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000019	d1000001-0000-4000-8000-000000000019	sf_bulk_25	demo25@metabase-demo.example.com	Demo Company 25	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000001a	d1000001-0000-4000-8000-00000000001a	sf_bulk_26	demo26@metabase-demo.example.com	Demo Company 26	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000001b	d1000001-0000-4000-8000-00000000001b	sf_bulk_27	demo27@metabase-demo.example.com	Demo Company 27	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000001c	d1000001-0000-4000-8000-00000000001c	sf_bulk_28	demo28@metabase-demo.example.com	Demo Company 28	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000001d	d1000001-0000-4000-8000-00000000001d	sf_bulk_29	demo29@metabase-demo.example.com	Demo Company 29	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000001e	d1000001-0000-4000-8000-00000000001e	sf_bulk_30	demo30@metabase-demo.example.com	Demo Company 30	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000001f	d1000001-0000-4000-8000-00000000001f	sf_bulk_31	demo31@metabase-demo.example.com	Demo Company 31	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000020	d1000001-0000-4000-8000-000000000020	sf_bulk_32	demo32@metabase-demo.example.com	Demo Company 32	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000021	d1000001-0000-4000-8000-000000000021	sf_bulk_33	demo33@metabase-demo.example.com	Demo Company 33	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000022	d1000001-0000-4000-8000-000000000022	sf_bulk_34	demo34@metabase-demo.example.com	Demo Company 34	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000023	d1000001-0000-4000-8000-000000000023	sf_bulk_35	demo35@metabase-demo.example.com	Demo Company 35	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000024	d1000001-0000-4000-8000-000000000024	sf_bulk_36	demo36@metabase-demo.example.com	Demo Company 36	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000025	d1000001-0000-4000-8000-000000000025	sf_bulk_37	demo37@metabase-demo.example.com	Demo Company 37	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000026	d1000001-0000-4000-8000-000000000026	sf_bulk_38	demo38@metabase-demo.example.com	Demo Company 38	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000027	d1000001-0000-4000-8000-000000000027	sf_bulk_39	demo39@metabase-demo.example.com	Demo Company 39	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000028	d1000001-0000-4000-8000-000000000028	sf_bulk_40	demo40@metabase-demo.example.com	Demo Company 40	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000029	d1000001-0000-4000-8000-000000000029	sf_bulk_41	demo41@metabase-demo.example.com	Demo Company 41	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000002a	d1000001-0000-4000-8000-00000000002a	sf_bulk_42	demo42@metabase-demo.example.com	Demo Company 42	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000002b	d1000001-0000-4000-8000-00000000002b	sf_bulk_43	demo43@metabase-demo.example.com	Demo Company 43	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000002c	d1000001-0000-4000-8000-00000000002c	sf_bulk_44	demo44@metabase-demo.example.com	Demo Company 44	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000002d	d1000001-0000-4000-8000-00000000002d	sf_bulk_45	demo45@metabase-demo.example.com	Demo Company 45	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000002e	d1000001-0000-4000-8000-00000000002e	sf_bulk_46	demo46@metabase-demo.example.com	Demo Company 46	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000002f	d1000001-0000-4000-8000-00000000002f	sf_bulk_47	demo47@metabase-demo.example.com	Demo Company 47	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000030	d1000001-0000-4000-8000-000000000030	sf_bulk_48	demo48@metabase-demo.example.com	Demo Company 48	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000031	d1000001-0000-4000-8000-000000000031	sf_bulk_49	demo49@metabase-demo.example.com	Demo Company 49	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000032	d1000001-0000-4000-8000-000000000032	sf_bulk_50	demo50@metabase-demo.example.com	Demo Company 50	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000033	d1000001-0000-4000-8000-000000000033	sf_bulk_51	demo51@metabase-demo.example.com	Demo Company 51	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000034	d1000001-0000-4000-8000-000000000034	sf_bulk_52	demo52@metabase-demo.example.com	Demo Company 52	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000035	d1000001-0000-4000-8000-000000000035	sf_bulk_53	demo53@metabase-demo.example.com	Demo Company 53	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000036	d1000001-0000-4000-8000-000000000036	sf_bulk_54	demo54@metabase-demo.example.com	Demo Company 54	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000037	d1000001-0000-4000-8000-000000000037	sf_bulk_55	demo55@metabase-demo.example.com	Demo Company 55	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000038	d1000001-0000-4000-8000-000000000038	sf_bulk_56	demo56@metabase-demo.example.com	Demo Company 56	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000039	d1000001-0000-4000-8000-000000000039	sf_bulk_57	demo57@metabase-demo.example.com	Demo Company 57	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000003a	d1000001-0000-4000-8000-00000000003a	sf_bulk_58	demo58@metabase-demo.example.com	Demo Company 58	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000003b	d1000001-0000-4000-8000-00000000003b	sf_bulk_59	demo59@metabase-demo.example.com	Demo Company 59	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000003c	d1000001-0000-4000-8000-00000000003c	sf_bulk_60	demo60@metabase-demo.example.com	Demo Company 60	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000003d	d1000001-0000-4000-8000-00000000003d	sf_bulk_61	demo61@metabase-demo.example.com	Demo Company 61	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000003e	d1000001-0000-4000-8000-00000000003e	sf_bulk_62	demo62@metabase-demo.example.com	Demo Company 62	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000003f	d1000001-0000-4000-8000-00000000003f	sf_bulk_63	demo63@metabase-demo.example.com	Demo Company 63	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000040	d1000001-0000-4000-8000-000000000040	sf_bulk_64	demo64@metabase-demo.example.com	Demo Company 64	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000041	d1000001-0000-4000-8000-000000000041	sf_bulk_65	demo65@metabase-demo.example.com	Demo Company 65	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000042	d1000001-0000-4000-8000-000000000042	sf_bulk_66	demo66@metabase-demo.example.com	Demo Company 66	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000043	d1000001-0000-4000-8000-000000000043	sf_bulk_67	demo67@metabase-demo.example.com	Demo Company 67	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000044	d1000001-0000-4000-8000-000000000044	sf_bulk_68	demo68@metabase-demo.example.com	Demo Company 68	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000045	d1000001-0000-4000-8000-000000000045	sf_bulk_69	demo69@metabase-demo.example.com	Demo Company 69	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000046	d1000001-0000-4000-8000-000000000046	sf_bulk_70	demo70@metabase-demo.example.com	Demo Company 70	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000047	d1000001-0000-4000-8000-000000000047	sf_bulk_71	demo71@metabase-demo.example.com	Demo Company 71	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000048	d1000001-0000-4000-8000-000000000048	sf_bulk_72	demo72@metabase-demo.example.com	Demo Company 72	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000049	d1000001-0000-4000-8000-000000000049	sf_bulk_73	demo73@metabase-demo.example.com	Demo Company 73	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000004a	d1000001-0000-4000-8000-00000000004a	sf_bulk_74	demo74@metabase-demo.example.com	Demo Company 74	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000004b	d1000001-0000-4000-8000-00000000004b	sf_bulk_75	demo75@metabase-demo.example.com	Demo Company 75	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000004c	d1000001-0000-4000-8000-00000000004c	sf_bulk_76	demo76@metabase-demo.example.com	Demo Company 76	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000004d	d1000001-0000-4000-8000-00000000004d	sf_bulk_77	demo77@metabase-demo.example.com	Demo Company 77	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000004e	d1000001-0000-4000-8000-00000000004e	sf_bulk_78	demo78@metabase-demo.example.com	Demo Company 78	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000004f	d1000001-0000-4000-8000-00000000004f	sf_bulk_79	demo79@metabase-demo.example.com	Demo Company 79	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000050	d1000001-0000-4000-8000-000000000050	sf_bulk_80	demo80@metabase-demo.example.com	Demo Company 80	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000051	d1000001-0000-4000-8000-000000000051	sf_bulk_81	demo81@metabase-demo.example.com	Demo Company 81	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000052	d1000001-0000-4000-8000-000000000052	sf_bulk_82	demo82@metabase-demo.example.com	Demo Company 82	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000053	d1000001-0000-4000-8000-000000000053	sf_bulk_83	demo83@metabase-demo.example.com	Demo Company 83	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000054	d1000001-0000-4000-8000-000000000054	sf_bulk_84	demo84@metabase-demo.example.com	Demo Company 84	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000055	d1000001-0000-4000-8000-000000000055	sf_bulk_85	demo85@metabase-demo.example.com	Demo Company 85	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000056	d1000001-0000-4000-8000-000000000056	sf_bulk_86	demo86@metabase-demo.example.com	Demo Company 86	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000057	d1000001-0000-4000-8000-000000000057	sf_bulk_87	demo87@metabase-demo.example.com	Demo Company 87	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000058	d1000001-0000-4000-8000-000000000058	sf_bulk_88	demo88@metabase-demo.example.com	Demo Company 88	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000059	d1000001-0000-4000-8000-000000000059	sf_bulk_89	demo89@metabase-demo.example.com	Demo Company 89	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000005a	d1000001-0000-4000-8000-00000000005a	sf_bulk_90	demo90@metabase-demo.example.com	Demo Company 90	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000005b	d1000001-0000-4000-8000-00000000005b	sf_bulk_91	demo91@metabase-demo.example.com	Demo Company 91	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000005c	d1000001-0000-4000-8000-00000000005c	sf_bulk_92	demo92@metabase-demo.example.com	Demo Company 92	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000005d	d1000001-0000-4000-8000-00000000005d	sf_bulk_93	demo93@metabase-demo.example.com	Demo Company 93	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000005e	d1000001-0000-4000-8000-00000000005e	sf_bulk_94	demo94@metabase-demo.example.com	Demo Company 94	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000005f	d1000001-0000-4000-8000-00000000005f	sf_bulk_95	demo95@metabase-demo.example.com	Demo Company 95	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000060	d1000001-0000-4000-8000-000000000060	sf_bulk_96	demo96@metabase-demo.example.com	Demo Company 96	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000061	d1000001-0000-4000-8000-000000000061	sf_bulk_97	demo97@metabase-demo.example.com	Demo Company 97	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000062	d1000001-0000-4000-8000-000000000062	sf_bulk_98	demo98@metabase-demo.example.com	Demo Company 98	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000063	d1000001-0000-4000-8000-000000000063	sf_bulk_99	demo99@metabase-demo.example.com	Demo Company 99	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000064	d1000001-0000-4000-8000-000000000064	sf_bulk_100	demo100@metabase-demo.example.com	Demo Company 100	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000065	d1000001-0000-4000-8000-000000000065	sf_bulk_101	demo101@metabase-demo.example.com	Demo Company 101	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000066	d1000001-0000-4000-8000-000000000066	sf_bulk_102	demo102@metabase-demo.example.com	Demo Company 102	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000067	d1000001-0000-4000-8000-000000000067	sf_bulk_103	demo103@metabase-demo.example.com	Demo Company 103	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000068	d1000001-0000-4000-8000-000000000068	sf_bulk_104	demo104@metabase-demo.example.com	Demo Company 104	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000069	d1000001-0000-4000-8000-000000000069	sf_bulk_105	demo105@metabase-demo.example.com	Demo Company 105	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000006a	d1000001-0000-4000-8000-00000000006a	sf_bulk_106	demo106@metabase-demo.example.com	Demo Company 106	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000006b	d1000001-0000-4000-8000-00000000006b	sf_bulk_107	demo107@metabase-demo.example.com	Demo Company 107	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000006c	d1000001-0000-4000-8000-00000000006c	sf_bulk_108	demo108@metabase-demo.example.com	Demo Company 108	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000006d	d1000001-0000-4000-8000-00000000006d	sf_bulk_109	demo109@metabase-demo.example.com	Demo Company 109	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000006e	d1000001-0000-4000-8000-00000000006e	sf_bulk_110	demo110@metabase-demo.example.com	Demo Company 110	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000006f	d1000001-0000-4000-8000-00000000006f	sf_bulk_111	demo111@metabase-demo.example.com	Demo Company 111	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000070	d1000001-0000-4000-8000-000000000070	sf_bulk_112	demo112@metabase-demo.example.com	Demo Company 112	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000071	d1000001-0000-4000-8000-000000000071	sf_bulk_113	demo113@metabase-demo.example.com	Demo Company 113	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000072	d1000001-0000-4000-8000-000000000072	sf_bulk_114	demo114@metabase-demo.example.com	Demo Company 114	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000073	d1000001-0000-4000-8000-000000000073	sf_bulk_115	demo115@metabase-demo.example.com	Demo Company 115	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000074	d1000001-0000-4000-8000-000000000074	sf_bulk_116	demo116@metabase-demo.example.com	Demo Company 116	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000075	d1000001-0000-4000-8000-000000000075	sf_bulk_117	demo117@metabase-demo.example.com	Demo Company 117	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000076	d1000001-0000-4000-8000-000000000076	sf_bulk_118	demo118@metabase-demo.example.com	Demo Company 118	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000077	d1000001-0000-4000-8000-000000000077	sf_bulk_119	demo119@metabase-demo.example.com	Demo Company 119	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000078	d1000001-0000-4000-8000-000000000078	sf_bulk_120	demo120@metabase-demo.example.com	Demo Company 120	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000079	d1000001-0000-4000-8000-000000000079	sf_bulk_121	demo121@metabase-demo.example.com	Demo Company 121	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000007a	d1000001-0000-4000-8000-00000000007a	sf_bulk_122	demo122@metabase-demo.example.com	Demo Company 122	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000007b	d1000001-0000-4000-8000-00000000007b	sf_bulk_123	demo123@metabase-demo.example.com	Demo Company 123	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000007c	d1000001-0000-4000-8000-00000000007c	sf_bulk_124	demo124@metabase-demo.example.com	Demo Company 124	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000007d	d1000001-0000-4000-8000-00000000007d	sf_bulk_125	demo125@metabase-demo.example.com	Demo Company 125	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000007e	d1000001-0000-4000-8000-00000000007e	sf_bulk_126	demo126@metabase-demo.example.com	Demo Company 126	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000007f	d1000001-0000-4000-8000-00000000007f	sf_bulk_127	demo127@metabase-demo.example.com	Demo Company 127	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000080	d1000001-0000-4000-8000-000000000080	sf_bulk_128	demo128@metabase-demo.example.com	Demo Company 128	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000081	d1000001-0000-4000-8000-000000000081	sf_bulk_129	demo129@metabase-demo.example.com	Demo Company 129	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000082	d1000001-0000-4000-8000-000000000082	sf_bulk_130	demo130@metabase-demo.example.com	Demo Company 130	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000083	d1000001-0000-4000-8000-000000000083	sf_bulk_131	demo131@metabase-demo.example.com	Demo Company 131	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000084	d1000001-0000-4000-8000-000000000084	sf_bulk_132	demo132@metabase-demo.example.com	Demo Company 132	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000085	d1000001-0000-4000-8000-000000000085	sf_bulk_133	demo133@metabase-demo.example.com	Demo Company 133	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000086	d1000001-0000-4000-8000-000000000086	sf_bulk_134	demo134@metabase-demo.example.com	Demo Company 134	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000087	d1000001-0000-4000-8000-000000000087	sf_bulk_135	demo135@metabase-demo.example.com	Demo Company 135	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000088	d1000001-0000-4000-8000-000000000088	sf_bulk_136	demo136@metabase-demo.example.com	Demo Company 136	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000089	d1000001-0000-4000-8000-000000000089	sf_bulk_137	demo137@metabase-demo.example.com	Demo Company 137	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000008a	d1000001-0000-4000-8000-00000000008a	sf_bulk_138	demo138@metabase-demo.example.com	Demo Company 138	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000008b	d1000001-0000-4000-8000-00000000008b	sf_bulk_139	demo139@metabase-demo.example.com	Demo Company 139	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000008c	d1000001-0000-4000-8000-00000000008c	sf_bulk_140	demo140@metabase-demo.example.com	Demo Company 140	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000008d	d1000001-0000-4000-8000-00000000008d	sf_bulk_141	demo141@metabase-demo.example.com	Demo Company 141	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000008e	d1000001-0000-4000-8000-00000000008e	sf_bulk_142	demo142@metabase-demo.example.com	Demo Company 142	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000008f	d1000001-0000-4000-8000-00000000008f	sf_bulk_143	demo143@metabase-demo.example.com	Demo Company 143	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000090	d1000001-0000-4000-8000-000000000090	sf_bulk_144	demo144@metabase-demo.example.com	Demo Company 144	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000091	d1000001-0000-4000-8000-000000000091	sf_bulk_145	demo145@metabase-demo.example.com	Demo Company 145	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000092	d1000001-0000-4000-8000-000000000092	sf_bulk_146	demo146@metabase-demo.example.com	Demo Company 146	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000093	d1000001-0000-4000-8000-000000000093	sf_bulk_147	demo147@metabase-demo.example.com	Demo Company 147	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000094	d1000001-0000-4000-8000-000000000094	sf_bulk_148	demo148@metabase-demo.example.com	Demo Company 148	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000095	d1000001-0000-4000-8000-000000000095	sf_bulk_149	demo149@metabase-demo.example.com	Demo Company 149	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000096	d1000001-0000-4000-8000-000000000096	sf_bulk_150	demo150@metabase-demo.example.com	Demo Company 150	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000097	d1000001-0000-4000-8000-000000000097	sf_bulk_151	demo151@metabase-demo.example.com	Demo Company 151	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000098	d1000001-0000-4000-8000-000000000098	sf_bulk_152	demo152@metabase-demo.example.com	Demo Company 152	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-000000000099	d1000001-0000-4000-8000-000000000099	sf_bulk_153	demo153@metabase-demo.example.com	Demo Company 153	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000009a	d1000001-0000-4000-8000-00000000009a	sf_bulk_154	demo154@metabase-demo.example.com	Demo Company 154	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000009b	d1000001-0000-4000-8000-00000000009b	sf_bulk_155	demo155@metabase-demo.example.com	Demo Company 155	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000009c	d1000001-0000-4000-8000-00000000009c	sf_bulk_156	demo156@metabase-demo.example.com	Demo Company 156	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000009d	d1000001-0000-4000-8000-00000000009d	sf_bulk_157	demo157@metabase-demo.example.com	Demo Company 157	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000009e	d1000001-0000-4000-8000-00000000009e	sf_bulk_158	demo158@metabase-demo.example.com	Demo Company 158	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-00000000009f	d1000001-0000-4000-8000-00000000009f	sf_bulk_159	demo159@metabase-demo.example.com	Demo Company 159	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a0	d1000001-0000-4000-8000-0000000000a0	sf_bulk_160	demo160@metabase-demo.example.com	Demo Company 160	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a1	d1000001-0000-4000-8000-0000000000a1	sf_bulk_161	demo161@metabase-demo.example.com	Demo Company 161	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a2	d1000001-0000-4000-8000-0000000000a2	sf_bulk_162	demo162@metabase-demo.example.com	Demo Company 162	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a3	d1000001-0000-4000-8000-0000000000a3	sf_bulk_163	demo163@metabase-demo.example.com	Demo Company 163	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a4	d1000001-0000-4000-8000-0000000000a4	sf_bulk_164	demo164@metabase-demo.example.com	Demo Company 164	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a5	d1000001-0000-4000-8000-0000000000a5	sf_bulk_165	demo165@metabase-demo.example.com	Demo Company 165	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a6	d1000001-0000-4000-8000-0000000000a6	sf_bulk_166	demo166@metabase-demo.example.com	Demo Company 166	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a7	d1000001-0000-4000-8000-0000000000a7	sf_bulk_167	demo167@metabase-demo.example.com	Demo Company 167	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a8	d1000001-0000-4000-8000-0000000000a8	sf_bulk_168	demo168@metabase-demo.example.com	Demo Company 168	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000a9	d1000001-0000-4000-8000-0000000000a9	sf_bulk_169	demo169@metabase-demo.example.com	Demo Company 169	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000aa	d1000001-0000-4000-8000-0000000000aa	sf_bulk_170	demo170@metabase-demo.example.com	Demo Company 170	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000ab	d1000001-0000-4000-8000-0000000000ab	sf_bulk_171	demo171@metabase-demo.example.com	Demo Company 171	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000ac	d1000001-0000-4000-8000-0000000000ac	sf_bulk_172	demo172@metabase-demo.example.com	Demo Company 172	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000ad	d1000001-0000-4000-8000-0000000000ad	sf_bulk_173	demo173@metabase-demo.example.com	Demo Company 173	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000ae	d1000001-0000-4000-8000-0000000000ae	sf_bulk_174	demo174@metabase-demo.example.com	Demo Company 174	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000af	d1000001-0000-4000-8000-0000000000af	sf_bulk_175	demo175@metabase-demo.example.com	Demo Company 175	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b0	d1000001-0000-4000-8000-0000000000b0	sf_bulk_176	demo176@metabase-demo.example.com	Demo Company 176	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b1	d1000001-0000-4000-8000-0000000000b1	sf_bulk_177	demo177@metabase-demo.example.com	Demo Company 177	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b2	d1000001-0000-4000-8000-0000000000b2	sf_bulk_178	demo178@metabase-demo.example.com	Demo Company 178	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b3	d1000001-0000-4000-8000-0000000000b3	sf_bulk_179	demo179@metabase-demo.example.com	Demo Company 179	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b4	d1000001-0000-4000-8000-0000000000b4	sf_bulk_180	demo180@metabase-demo.example.com	Demo Company 180	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b5	d1000001-0000-4000-8000-0000000000b5	sf_bulk_181	demo181@metabase-demo.example.com	Demo Company 181	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b6	d1000001-0000-4000-8000-0000000000b6	sf_bulk_182	demo182@metabase-demo.example.com	Demo Company 182	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b7	d1000001-0000-4000-8000-0000000000b7	sf_bulk_183	demo183@metabase-demo.example.com	Demo Company 183	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b8	d1000001-0000-4000-8000-0000000000b8	sf_bulk_184	demo184@metabase-demo.example.com	Demo Company 184	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000b9	d1000001-0000-4000-8000-0000000000b9	sf_bulk_185	demo185@metabase-demo.example.com	Demo Company 185	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000ba	d1000001-0000-4000-8000-0000000000ba	sf_bulk_186	demo186@metabase-demo.example.com	Demo Company 186	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000bb	d1000001-0000-4000-8000-0000000000bb	sf_bulk_187	demo187@metabase-demo.example.com	Demo Company 187	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000bc	d1000001-0000-4000-8000-0000000000bc	sf_bulk_188	demo188@metabase-demo.example.com	Demo Company 188	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000bd	d1000001-0000-4000-8000-0000000000bd	sf_bulk_189	demo189@metabase-demo.example.com	Demo Company 189	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000be	d1000001-0000-4000-8000-0000000000be	sf_bulk_190	demo190@metabase-demo.example.com	Demo Company 190	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000bf	d1000001-0000-4000-8000-0000000000bf	sf_bulk_191	demo191@metabase-demo.example.com	Demo Company 191	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c0	d1000001-0000-4000-8000-0000000000c0	sf_bulk_192	demo192@metabase-demo.example.com	Demo Company 192	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c1	d1000001-0000-4000-8000-0000000000c1	sf_bulk_193	demo193@metabase-demo.example.com	Demo Company 193	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c2	d1000001-0000-4000-8000-0000000000c2	sf_bulk_194	demo194@metabase-demo.example.com	Demo Company 194	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c3	d1000001-0000-4000-8000-0000000000c3	sf_bulk_195	demo195@metabase-demo.example.com	Demo Company 195	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c4	d1000001-0000-4000-8000-0000000000c4	sf_bulk_196	demo196@metabase-demo.example.com	Demo Company 196	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c5	d1000001-0000-4000-8000-0000000000c5	sf_bulk_197	demo197@metabase-demo.example.com	Demo Company 197	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c6	d1000001-0000-4000-8000-0000000000c6	sf_bulk_198	demo198@metabase-demo.example.com	Demo Company 198	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c7	d1000001-0000-4000-8000-0000000000c7	sf_bulk_199	demo199@metabase-demo.example.com	Demo Company 199	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c8	d1000001-0000-4000-8000-0000000000c8	sf_bulk_200	demo200@metabase-demo.example.com	Demo Company 200	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000c9	d1000001-0000-4000-8000-0000000000c9	sf_bulk_201	demo201@metabase-demo.example.com	Demo Company 201	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000ca	d1000001-0000-4000-8000-0000000000ca	sf_bulk_202	demo202@metabase-demo.example.com	Demo Company 202	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000cb	d1000001-0000-4000-8000-0000000000cb	sf_bulk_203	demo203@metabase-demo.example.com	Demo Company 203	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000cc	d1000001-0000-4000-8000-0000000000cc	sf_bulk_204	demo204@metabase-demo.example.com	Demo Company 204	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000cd	d1000001-0000-4000-8000-0000000000cd	sf_bulk_205	demo205@metabase-demo.example.com	Demo Company 205	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000ce	d1000001-0000-4000-8000-0000000000ce	sf_bulk_206	demo206@metabase-demo.example.com	Demo Company 206	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000cf	d1000001-0000-4000-8000-0000000000cf	sf_bulk_207	demo207@metabase-demo.example.com	Demo Company 207	Partner	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000d0	d1000001-0000-4000-8000-0000000000d0	sf_bulk_208	demo208@metabase-demo.example.com	Demo Company 208	Event	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000d1	d1000001-0000-4000-8000-0000000000d1	sf_bulk_209	demo209@metabase-demo.example.com	Demo Company 209	Referral	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
d3000002-0000-4000-8000-0000000000d2	d1000001-0000-4000-8000-0000000000d2	sf_bulk_210	demo210@metabase-demo.example.com	Demo Company 210	Website	2026-02-25 11:38:31.491288+00	2026-02-25 11:38:31.491288+00
\.


--
-- Data for Name: salesforce_opportunities; Type: TABLE DATA; Schema: demo; Owner: apiary
--

COPY demo.salesforce_opportunities (id, contact_id, name, amount_cents, stage, closed_at, created_at) FROM stdin;
2ed138ad-6254-41a6-b5db-2f943481f8f8	501c94ba-ab31-45c6-83ad-871937c353f6	Demo Opp demo4@metabase-demo.example.com	136204	Closed Won	2026-02-12 11:38:31.417266+00	2026-02-25 11:38:31.417266+00
3c4e77dd-525d-4f26-aa43-07d5e662a3f6	4fc10ff1-5f48-4c85-92fb-de21d8689cbd	Demo Opp demo2@metabase-demo.example.com	124973	Closed Won	2025-12-06 11:38:31.417266+00	2026-02-25 11:38:31.417266+00
73ec4fa0-8f9c-4826-92e9-ae5b2b9be3b4	4bd75583-a08b-4edf-9c4b-997dc1c26c67	Demo Opp demo3@metabase-demo.example.com	126847	Closed Won	2025-12-19 11:38:31.417266+00	2026-02-25 11:38:31.417266+00
194aecbb-f224-4264-859b-e8ec0b86c7f9	a4cf6ef9-b7f2-473d-84e6-0dfedd883f0d	Demo Opp demo1@metabase-demo.example.com	119456	Closed Won	2026-01-30 11:38:31.417266+00	2026-02-25 11:38:31.417266+00
d3000003-0000-4000-8000-000000000001	d3000002-0000-4000-8000-00000000000b	Opp 11-1	31500	Closed Lost	2026-02-20 11:38:31.49818+00	2026-02-20 11:38:31.49818+00
d3000003-0000-4000-8000-000000000003	d3000002-0000-4000-8000-00000000000c	Opp 12-1	32500	Closed Won	2026-02-17 11:38:31.49818+00	2026-02-17 11:38:31.49818+00
d3000003-0000-4000-8000-000000000005	d3000002-0000-4000-8000-00000000000d	Opp 13-1	33500	Closed Won	2026-02-14 11:38:31.49818+00	2026-02-14 11:38:31.49818+00
d3000003-0000-4000-8000-000000000007	d3000002-0000-4000-8000-00000000000e	Opp 14-1	34500	Closed Lost	2026-02-11 11:38:31.49818+00	2026-02-11 11:38:31.49818+00
d3000003-0000-4000-8000-000000000009	d3000002-0000-4000-8000-00000000000f	Opp 15-1	35500	Closed Won	2026-02-08 11:38:31.49818+00	2026-02-08 11:38:31.49818+00
d3000003-0000-4000-8000-00000000000b	d3000002-0000-4000-8000-000000000010	Opp 16-1	36500	Closed Won	2026-02-05 11:38:31.49818+00	2026-02-05 11:38:31.49818+00
d3000003-0000-4000-8000-00000000000d	d3000002-0000-4000-8000-000000000011	Opp 17-1	37500	Closed Lost	2026-02-02 11:38:31.49818+00	2026-02-02 11:38:31.49818+00
d3000003-0000-4000-8000-00000000000f	d3000002-0000-4000-8000-000000000012	Opp 18-1	38500	Closed Won	2026-01-30 11:38:31.49818+00	2026-01-30 11:38:31.49818+00
d3000003-0000-4000-8000-000000000011	d3000002-0000-4000-8000-000000000013	Opp 19-1	39500	Closed Won	2026-01-27 11:38:31.49818+00	2026-01-27 11:38:31.49818+00
d3000003-0000-4000-8000-000000000013	d3000002-0000-4000-8000-000000000014	Opp 20-1	40500	Closed Lost	2026-01-24 11:38:31.49818+00	2026-01-24 11:38:31.49818+00
d3000003-0000-4000-8000-000000000015	d3000002-0000-4000-8000-000000000015	Opp 21-1	41500	Closed Won	2026-01-21 11:38:31.49818+00	2026-01-21 11:38:31.49818+00
d3000003-0000-4000-8000-000000000017	d3000002-0000-4000-8000-000000000016	Opp 22-1	42500	Closed Won	2026-01-18 11:38:31.49818+00	2026-01-18 11:38:31.49818+00
d3000003-0000-4000-8000-000000000019	d3000002-0000-4000-8000-000000000017	Opp 23-1	43500	Closed Lost	2026-01-15 11:38:31.49818+00	2026-01-15 11:38:31.49818+00
d3000003-0000-4000-8000-00000000001b	d3000002-0000-4000-8000-000000000018	Opp 24-1	44500	Closed Won	2026-01-12 11:38:31.49818+00	2026-01-12 11:38:31.49818+00
d3000003-0000-4000-8000-00000000001d	d3000002-0000-4000-8000-000000000019	Opp 25-1	45500	Closed Won	2026-01-09 11:38:31.49818+00	2026-01-09 11:38:31.49818+00
d3000003-0000-4000-8000-00000000001f	d3000002-0000-4000-8000-00000000001a	Opp 26-1	46500	Closed Lost	2026-01-06 11:38:31.49818+00	2026-01-06 11:38:31.49818+00
d3000003-0000-4000-8000-000000000021	d3000002-0000-4000-8000-00000000001b	Opp 27-1	47500	Closed Won	2026-01-03 11:38:31.49818+00	2026-01-03 11:38:31.49818+00
d3000003-0000-4000-8000-000000000023	d3000002-0000-4000-8000-00000000001c	Opp 28-1	48500	Closed Won	2025-12-31 11:38:31.49818+00	2025-12-31 11:38:31.49818+00
d3000003-0000-4000-8000-000000000025	d3000002-0000-4000-8000-00000000001d	Opp 29-1	49500	Closed Lost	2025-12-28 11:38:31.49818+00	2025-12-28 11:38:31.49818+00
d3000003-0000-4000-8000-000000000027	d3000002-0000-4000-8000-00000000001e	Opp 30-1	50500	Closed Won	2025-12-25 11:38:31.49818+00	2025-12-25 11:38:31.49818+00
d3000003-0000-4000-8000-000000000029	d3000002-0000-4000-8000-00000000001f	Opp 31-1	51500	Closed Won	2025-12-22 11:38:31.49818+00	2025-12-22 11:38:31.49818+00
d3000003-0000-4000-8000-00000000002b	d3000002-0000-4000-8000-000000000020	Opp 32-1	52500	Closed Lost	2025-12-19 11:38:31.49818+00	2025-12-19 11:38:31.49818+00
d3000003-0000-4000-8000-00000000002d	d3000002-0000-4000-8000-000000000021	Opp 33-1	53500	Closed Won	2025-12-16 11:38:31.49818+00	2025-12-16 11:38:31.49818+00
d3000003-0000-4000-8000-00000000002f	d3000002-0000-4000-8000-000000000022	Opp 34-1	54500	Closed Won	2025-12-13 11:38:31.49818+00	2025-12-13 11:38:31.49818+00
d3000003-0000-4000-8000-000000000031	d3000002-0000-4000-8000-000000000023	Opp 35-1	55500	Closed Lost	2025-12-10 11:38:31.49818+00	2025-12-10 11:38:31.49818+00
d3000003-0000-4000-8000-000000000033	d3000002-0000-4000-8000-000000000024	Opp 36-1	56500	Closed Won	2025-12-07 11:38:31.49818+00	2025-12-07 11:38:31.49818+00
d3000003-0000-4000-8000-000000000035	d3000002-0000-4000-8000-000000000025	Opp 37-1	57500	Closed Won	2025-12-04 11:38:31.49818+00	2025-12-04 11:38:31.49818+00
d3000003-0000-4000-8000-000000000037	d3000002-0000-4000-8000-000000000026	Opp 38-1	58500	Closed Lost	2025-12-01 11:38:31.49818+00	2025-12-01 11:38:31.49818+00
d3000003-0000-4000-8000-000000000039	d3000002-0000-4000-8000-000000000027	Opp 39-1	59500	Closed Won	2025-11-28 11:38:31.49818+00	2025-11-28 11:38:31.49818+00
d3000003-0000-4000-8000-00000000003b	d3000002-0000-4000-8000-000000000028	Opp 40-1	60500	Closed Won	2025-11-25 11:38:31.49818+00	2025-11-25 11:38:31.49818+00
d3000003-0000-4000-8000-00000000003d	d3000002-0000-4000-8000-000000000029	Opp 41-1	61500	Closed Lost	2025-11-22 11:38:31.49818+00	2025-11-22 11:38:31.49818+00
d3000003-0000-4000-8000-00000000003f	d3000002-0000-4000-8000-00000000002a	Opp 42-1	62500	Closed Won	2025-11-19 11:38:31.49818+00	2025-11-19 11:38:31.49818+00
d3000003-0000-4000-8000-000000000041	d3000002-0000-4000-8000-00000000002b	Opp 43-1	63500	Closed Won	2025-11-16 11:38:31.49818+00	2025-11-16 11:38:31.49818+00
d3000003-0000-4000-8000-000000000043	d3000002-0000-4000-8000-00000000002c	Opp 44-1	64500	Closed Lost	2025-11-13 11:38:31.49818+00	2025-11-13 11:38:31.49818+00
d3000003-0000-4000-8000-000000000045	d3000002-0000-4000-8000-00000000002d	Opp 45-1	65500	Closed Won	2025-11-10 11:38:31.49818+00	2025-11-10 11:38:31.49818+00
d3000003-0000-4000-8000-000000000047	d3000002-0000-4000-8000-00000000002e	Opp 46-1	66500	Closed Won	2025-11-07 11:38:31.49818+00	2025-11-07 11:38:31.49818+00
d3000003-0000-4000-8000-000000000049	d3000002-0000-4000-8000-00000000002f	Opp 47-1	67500	Closed Lost	2025-11-04 11:38:31.49818+00	2025-11-04 11:38:31.49818+00
d3000003-0000-4000-8000-00000000004b	d3000002-0000-4000-8000-000000000030	Opp 48-1	68500	Closed Won	2025-11-01 11:38:31.49818+00	2025-11-01 11:38:31.49818+00
d3000003-0000-4000-8000-00000000004d	d3000002-0000-4000-8000-000000000031	Opp 49-1	69500	Closed Won	2025-10-29 11:38:31.49818+00	2025-10-29 11:38:31.49818+00
d3000003-0000-4000-8000-00000000004f	d3000002-0000-4000-8000-000000000032	Opp 50-1	70500	Closed Lost	2025-10-26 11:38:31.49818+00	2025-10-26 11:38:31.49818+00
d3000003-0000-4000-8000-000000000051	d3000002-0000-4000-8000-000000000033	Opp 51-1	71500	Closed Won	2025-10-23 11:38:31.49818+00	2025-10-23 11:38:31.49818+00
d3000003-0000-4000-8000-000000000053	d3000002-0000-4000-8000-000000000034	Opp 52-1	72500	Closed Won	2025-10-20 11:38:31.49818+00	2025-10-20 11:38:31.49818+00
d3000003-0000-4000-8000-000000000055	d3000002-0000-4000-8000-000000000035	Opp 53-1	73500	Closed Lost	2025-10-17 11:38:31.49818+00	2025-10-17 11:38:31.49818+00
d3000003-0000-4000-8000-000000000057	d3000002-0000-4000-8000-000000000036	Opp 54-1	74500	Closed Won	2025-10-14 11:38:31.49818+00	2025-10-14 11:38:31.49818+00
d3000003-0000-4000-8000-000000000059	d3000002-0000-4000-8000-000000000037	Opp 55-1	75500	Closed Won	2025-10-11 11:38:31.49818+00	2025-10-11 11:38:31.49818+00
d3000003-0000-4000-8000-00000000005b	d3000002-0000-4000-8000-000000000038	Opp 56-1	76500	Closed Lost	2025-10-08 11:38:31.49818+00	2025-10-08 11:38:31.49818+00
d3000003-0000-4000-8000-00000000005d	d3000002-0000-4000-8000-000000000039	Opp 57-1	77500	Closed Won	2025-10-05 11:38:31.49818+00	2025-10-05 11:38:31.49818+00
d3000003-0000-4000-8000-00000000005f	d3000002-0000-4000-8000-00000000003a	Opp 58-1	78500	Closed Won	2025-10-02 11:38:31.49818+00	2025-10-02 11:38:31.49818+00
d3000003-0000-4000-8000-000000000061	d3000002-0000-4000-8000-00000000003b	Opp 59-1	79500	Closed Lost	2025-09-29 11:38:31.49818+00	2025-09-29 11:38:31.49818+00
d3000003-0000-4000-8000-000000000063	d3000002-0000-4000-8000-00000000003c	Opp 60-1	80500	Closed Won	2025-09-26 11:38:31.49818+00	2025-09-26 11:38:31.49818+00
d3000003-0000-4000-8000-000000000065	d3000002-0000-4000-8000-00000000003d	Opp 61-1	81500	Closed Won	2025-09-23 11:38:31.49818+00	2025-09-23 11:38:31.49818+00
d3000003-0000-4000-8000-000000000067	d3000002-0000-4000-8000-00000000003e	Opp 62-1	82500	Closed Lost	2025-09-20 11:38:31.49818+00	2025-09-20 11:38:31.49818+00
d3000003-0000-4000-8000-000000000069	d3000002-0000-4000-8000-00000000003f	Opp 63-1	83500	Closed Won	2025-09-17 11:38:31.49818+00	2025-09-17 11:38:31.49818+00
d3000003-0000-4000-8000-00000000006b	d3000002-0000-4000-8000-000000000040	Opp 64-1	84500	Closed Won	2025-09-14 11:38:31.49818+00	2025-09-14 11:38:31.49818+00
d3000003-0000-4000-8000-00000000006d	d3000002-0000-4000-8000-000000000041	Opp 65-1	85500	Closed Lost	2025-09-11 11:38:31.49818+00	2025-09-11 11:38:31.49818+00
d3000003-0000-4000-8000-00000000006f	d3000002-0000-4000-8000-000000000042	Opp 66-1	86500	Closed Won	2025-09-08 11:38:31.49818+00	2025-09-08 11:38:31.49818+00
d3000003-0000-4000-8000-000000000071	d3000002-0000-4000-8000-000000000043	Opp 67-1	87500	Closed Won	2025-09-05 11:38:31.49818+00	2025-09-05 11:38:31.49818+00
d3000003-0000-4000-8000-000000000073	d3000002-0000-4000-8000-000000000044	Opp 68-1	88500	Closed Lost	2025-09-02 11:38:31.49818+00	2025-09-02 11:38:31.49818+00
d3000003-0000-4000-8000-000000000075	d3000002-0000-4000-8000-000000000045	Opp 69-1	89500	Closed Won	2025-08-30 11:38:31.49818+00	2025-08-30 11:38:31.49818+00
d3000003-0000-4000-8000-000000000077	d3000002-0000-4000-8000-000000000046	Opp 70-1	90500	Closed Won	2025-08-27 11:38:31.49818+00	2025-08-27 11:38:31.49818+00
d3000003-0000-4000-8000-000000000079	d3000002-0000-4000-8000-000000000047	Opp 71-1	91500	Closed Lost	2025-08-24 11:38:31.49818+00	2025-08-24 11:38:31.49818+00
d3000003-0000-4000-8000-00000000007b	d3000002-0000-4000-8000-000000000048	Opp 72-1	92500	Closed Won	2025-08-21 11:38:31.49818+00	2025-08-21 11:38:31.49818+00
d3000003-0000-4000-8000-00000000007d	d3000002-0000-4000-8000-000000000049	Opp 73-1	93500	Closed Won	2025-08-18 11:38:31.49818+00	2025-08-18 11:38:31.49818+00
d3000003-0000-4000-8000-00000000007f	d3000002-0000-4000-8000-00000000004a	Opp 74-1	94500	Closed Lost	2025-08-15 11:38:31.49818+00	2025-08-15 11:38:31.49818+00
d3000003-0000-4000-8000-000000000081	d3000002-0000-4000-8000-00000000004b	Opp 75-1	95500	Closed Won	2025-08-12 11:38:31.49818+00	2025-08-12 11:38:31.49818+00
d3000003-0000-4000-8000-000000000083	d3000002-0000-4000-8000-00000000004c	Opp 76-1	96500	Closed Won	2025-08-09 11:38:31.49818+00	2025-08-09 11:38:31.49818+00
d3000003-0000-4000-8000-000000000085	d3000002-0000-4000-8000-00000000004d	Opp 77-1	97500	Closed Lost	2025-08-06 11:38:31.49818+00	2025-08-06 11:38:31.49818+00
d3000003-0000-4000-8000-000000000087	d3000002-0000-4000-8000-00000000004e	Opp 78-1	98500	Closed Won	2025-08-03 11:38:31.49818+00	2025-08-03 11:38:31.49818+00
d3000003-0000-4000-8000-000000000089	d3000002-0000-4000-8000-00000000004f	Opp 79-1	99500	Closed Won	2025-07-31 11:38:31.49818+00	2025-07-31 11:38:31.49818+00
d3000003-0000-4000-8000-00000000008b	d3000002-0000-4000-8000-000000000050	Opp 80-1	100500	Closed Lost	2025-07-28 11:38:31.49818+00	2025-07-28 11:38:31.49818+00
d3000003-0000-4000-8000-00000000008d	d3000002-0000-4000-8000-000000000051	Opp 81-1	101500	Closed Won	2025-07-25 11:38:31.49818+00	2025-07-25 11:38:31.49818+00
d3000003-0000-4000-8000-00000000008f	d3000002-0000-4000-8000-000000000052	Opp 82-1	102500	Closed Won	2025-07-22 11:38:31.49818+00	2025-07-22 11:38:31.49818+00
d3000003-0000-4000-8000-000000000091	d3000002-0000-4000-8000-000000000053	Opp 83-1	103500	Closed Lost	2025-07-19 11:38:31.49818+00	2025-07-19 11:38:31.49818+00
d3000003-0000-4000-8000-000000000093	d3000002-0000-4000-8000-000000000054	Opp 84-1	104500	Closed Won	2025-07-16 11:38:31.49818+00	2025-07-16 11:38:31.49818+00
d3000003-0000-4000-8000-000000000095	d3000002-0000-4000-8000-000000000055	Opp 85-1	105500	Closed Won	2025-07-13 11:38:31.49818+00	2025-07-13 11:38:31.49818+00
d3000003-0000-4000-8000-000000000097	d3000002-0000-4000-8000-000000000056	Opp 86-1	106500	Closed Lost	2025-07-10 11:38:31.49818+00	2025-07-10 11:38:31.49818+00
d3000003-0000-4000-8000-000000000099	d3000002-0000-4000-8000-000000000057	Opp 87-1	107500	Closed Won	2025-07-07 11:38:31.49818+00	2025-07-07 11:38:31.49818+00
d3000003-0000-4000-8000-00000000009b	d3000002-0000-4000-8000-000000000058	Opp 88-1	108500	Closed Won	2025-07-04 11:38:31.49818+00	2025-07-04 11:38:31.49818+00
d3000003-0000-4000-8000-00000000009d	d3000002-0000-4000-8000-000000000059	Opp 89-1	109500	Closed Lost	2025-07-01 11:38:31.49818+00	2025-07-01 11:38:31.49818+00
d3000003-0000-4000-8000-00000000009f	d3000002-0000-4000-8000-00000000005a	Opp 90-1	110500	Closed Won	2025-06-28 11:38:31.49818+00	2025-06-28 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a1	d3000002-0000-4000-8000-00000000005b	Opp 91-1	111500	Closed Won	2025-06-25 11:38:31.49818+00	2025-06-25 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a3	d3000002-0000-4000-8000-00000000005c	Opp 92-1	112500	Closed Lost	2025-06-22 11:38:31.49818+00	2025-06-22 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a5	d3000002-0000-4000-8000-00000000005d	Opp 93-1	113500	Closed Won	2025-06-19 11:38:31.49818+00	2025-06-19 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a7	d3000002-0000-4000-8000-00000000005e	Opp 94-1	114500	Closed Won	2025-06-16 11:38:31.49818+00	2025-06-16 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a9	d3000002-0000-4000-8000-00000000005f	Opp 95-1	115500	Closed Lost	2025-06-13 11:38:31.49818+00	2025-06-13 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ab	d3000002-0000-4000-8000-000000000060	Opp 96-1	116500	Closed Won	2025-06-10 11:38:31.49818+00	2025-06-10 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ad	d3000002-0000-4000-8000-000000000061	Opp 97-1	117500	Closed Won	2025-06-07 11:38:31.49818+00	2025-06-07 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000af	d3000002-0000-4000-8000-000000000062	Opp 98-1	118500	Closed Lost	2025-06-04 11:38:31.49818+00	2025-06-04 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b1	d3000002-0000-4000-8000-000000000063	Opp 99-1	119500	Closed Won	2025-06-01 11:38:31.49818+00	2025-06-01 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b3	d3000002-0000-4000-8000-000000000064	Opp 100-1	120500	Closed Won	2025-05-29 11:38:31.49818+00	2025-05-29 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b5	d3000002-0000-4000-8000-000000000065	Opp 101-1	121500	Closed Lost	2025-05-26 11:38:31.49818+00	2025-05-26 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b7	d3000002-0000-4000-8000-000000000066	Opp 102-1	122500	Closed Won	2025-05-23 11:38:31.49818+00	2025-05-23 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b9	d3000002-0000-4000-8000-000000000067	Opp 103-1	123500	Closed Won	2025-05-20 11:38:31.49818+00	2025-05-20 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000bb	d3000002-0000-4000-8000-000000000068	Opp 104-1	124500	Closed Lost	2025-05-17 11:38:31.49818+00	2025-05-17 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000bd	d3000002-0000-4000-8000-000000000069	Opp 105-1	125500	Closed Won	2025-05-14 11:38:31.49818+00	2025-05-14 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000bf	d3000002-0000-4000-8000-00000000006a	Opp 106-1	126500	Closed Won	2025-05-11 11:38:31.49818+00	2025-05-11 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c1	d3000002-0000-4000-8000-00000000006b	Opp 107-1	127500	Closed Lost	2025-05-08 11:38:31.49818+00	2025-05-08 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c3	d3000002-0000-4000-8000-00000000006c	Opp 108-1	128500	Closed Won	2025-05-05 11:38:31.49818+00	2025-05-05 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c5	d3000002-0000-4000-8000-00000000006d	Opp 109-1	129500	Closed Won	2025-05-02 11:38:31.49818+00	2025-05-02 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c7	d3000002-0000-4000-8000-00000000006e	Opp 110-1	130500	Closed Lost	2025-04-29 11:38:31.49818+00	2025-04-29 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c9	d3000002-0000-4000-8000-00000000006f	Opp 111-1	131500	Closed Won	2025-04-26 11:38:31.49818+00	2025-04-26 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000cb	d3000002-0000-4000-8000-000000000070	Opp 112-1	132500	Closed Won	2025-04-23 11:38:31.49818+00	2025-04-23 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000cd	d3000002-0000-4000-8000-000000000071	Opp 113-1	133500	Closed Lost	2025-04-20 11:38:31.49818+00	2025-04-20 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000cf	d3000002-0000-4000-8000-000000000072	Opp 114-1	134500	Closed Won	2025-04-17 11:38:31.49818+00	2025-04-17 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d1	d3000002-0000-4000-8000-000000000073	Opp 115-1	135500	Closed Won	2025-04-14 11:38:31.49818+00	2025-04-14 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d3	d3000002-0000-4000-8000-000000000074	Opp 116-1	136500	Closed Lost	2025-04-11 11:38:31.49818+00	2025-04-11 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d5	d3000002-0000-4000-8000-000000000075	Opp 117-1	137500	Closed Won	2025-04-08 11:38:31.49818+00	2025-04-08 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d7	d3000002-0000-4000-8000-000000000076	Opp 118-1	138500	Closed Won	2025-04-05 11:38:31.49818+00	2025-04-05 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d9	d3000002-0000-4000-8000-000000000077	Opp 119-1	139500	Closed Lost	2025-04-02 11:38:31.49818+00	2025-04-02 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000db	d3000002-0000-4000-8000-000000000078	Opp 120-1	140500	Closed Won	2025-03-30 11:38:31.49818+00	2025-03-30 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000dd	d3000002-0000-4000-8000-000000000079	Opp 121-1	141500	Closed Won	2025-03-27 11:38:31.49818+00	2025-03-27 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000df	d3000002-0000-4000-8000-00000000007a	Opp 122-1	142500	Closed Lost	2025-03-24 11:38:31.49818+00	2025-03-24 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e1	d3000002-0000-4000-8000-00000000007b	Opp 123-1	143500	Closed Won	2025-03-21 11:38:31.49818+00	2025-03-21 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e3	d3000002-0000-4000-8000-00000000007c	Opp 124-1	144500	Closed Won	2025-03-18 11:38:31.49818+00	2025-03-18 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e5	d3000002-0000-4000-8000-00000000007d	Opp 125-1	145500	Closed Lost	2025-03-15 11:38:31.49818+00	2025-03-15 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e7	d3000002-0000-4000-8000-00000000007e	Opp 126-1	146500	Closed Won	2025-03-12 11:38:31.49818+00	2025-03-12 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e9	d3000002-0000-4000-8000-00000000007f	Opp 127-1	147500	Closed Won	2025-03-09 11:38:31.49818+00	2025-03-09 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000eb	d3000002-0000-4000-8000-000000000080	Opp 128-1	148500	Closed Lost	2025-03-06 11:38:31.49818+00	2025-03-06 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ed	d3000002-0000-4000-8000-000000000081	Opp 129-1	149500	Closed Won	2025-03-03 11:38:31.49818+00	2025-03-03 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ef	d3000002-0000-4000-8000-000000000082	Opp 130-1	150500	Closed Won	2025-02-28 11:38:31.49818+00	2025-02-28 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f1	d3000002-0000-4000-8000-000000000083	Opp 131-1	151500	Closed Lost	2025-02-25 11:38:31.49818+00	2025-02-25 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f3	d3000002-0000-4000-8000-000000000084	Opp 132-1	152500	Closed Won	2025-02-22 11:38:31.49818+00	2025-02-22 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f5	d3000002-0000-4000-8000-000000000085	Opp 133-1	153500	Closed Won	2025-02-19 11:38:31.49818+00	2025-02-19 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f7	d3000002-0000-4000-8000-000000000086	Opp 134-1	154500	Closed Lost	2025-02-16 11:38:31.49818+00	2025-02-16 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f9	d3000002-0000-4000-8000-000000000087	Opp 135-1	155500	Closed Won	2025-02-13 11:38:31.49818+00	2025-02-13 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000fb	d3000002-0000-4000-8000-000000000088	Opp 136-1	156500	Closed Won	2025-02-10 11:38:31.49818+00	2025-02-10 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000fd	d3000002-0000-4000-8000-000000000089	Opp 137-1	157500	Closed Lost	2025-02-07 11:38:31.49818+00	2025-02-07 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ff	d3000002-0000-4000-8000-00000000008a	Opp 138-1	158500	Closed Won	2025-02-04 11:38:31.49818+00	2025-02-04 11:38:31.49818+00
d3000003-0000-4000-8000-000000000101	d3000002-0000-4000-8000-00000000008b	Opp 139-1	159500	Closed Won	2025-02-01 11:38:31.49818+00	2025-02-01 11:38:31.49818+00
d3000003-0000-4000-8000-000000000103	d3000002-0000-4000-8000-00000000008c	Opp 140-1	160500	Closed Lost	2025-01-29 11:38:31.49818+00	2025-01-29 11:38:31.49818+00
d3000003-0000-4000-8000-000000000105	d3000002-0000-4000-8000-00000000008d	Opp 141-1	161500	Closed Won	2025-01-26 11:38:31.49818+00	2025-01-26 11:38:31.49818+00
d3000003-0000-4000-8000-000000000107	d3000002-0000-4000-8000-00000000008e	Opp 142-1	162500	Closed Won	2025-01-23 11:38:31.49818+00	2025-01-23 11:38:31.49818+00
d3000003-0000-4000-8000-000000000109	d3000002-0000-4000-8000-00000000008f	Opp 143-1	163500	Closed Lost	2025-01-20 11:38:31.49818+00	2025-01-20 11:38:31.49818+00
d3000003-0000-4000-8000-00000000010b	d3000002-0000-4000-8000-000000000090	Opp 144-1	164500	Closed Won	2025-01-17 11:38:31.49818+00	2025-01-17 11:38:31.49818+00
d3000003-0000-4000-8000-00000000010d	d3000002-0000-4000-8000-000000000091	Opp 145-1	165500	Closed Won	2025-01-14 11:38:31.49818+00	2025-01-14 11:38:31.49818+00
d3000003-0000-4000-8000-00000000010f	d3000002-0000-4000-8000-000000000092	Opp 146-1	166500	Closed Lost	2025-01-11 11:38:31.49818+00	2025-01-11 11:38:31.49818+00
d3000003-0000-4000-8000-000000000111	d3000002-0000-4000-8000-000000000093	Opp 147-1	167500	Closed Won	2025-01-08 11:38:31.49818+00	2025-01-08 11:38:31.49818+00
d3000003-0000-4000-8000-000000000113	d3000002-0000-4000-8000-000000000094	Opp 148-1	168500	Closed Won	2025-01-05 11:38:31.49818+00	2025-01-05 11:38:31.49818+00
d3000003-0000-4000-8000-000000000115	d3000002-0000-4000-8000-000000000095	Opp 149-1	169500	Closed Lost	2025-01-02 11:38:31.49818+00	2025-01-02 11:38:31.49818+00
d3000003-0000-4000-8000-000000000117	d3000002-0000-4000-8000-000000000096	Opp 150-1	170500	Closed Won	2024-12-30 11:38:31.49818+00	2024-12-30 11:38:31.49818+00
d3000003-0000-4000-8000-000000000119	d3000002-0000-4000-8000-000000000097	Opp 151-1	171500	Closed Won	2024-12-27 11:38:31.49818+00	2024-12-27 11:38:31.49818+00
d3000003-0000-4000-8000-00000000011b	d3000002-0000-4000-8000-000000000098	Opp 152-1	172500	Closed Lost	2024-12-24 11:38:31.49818+00	2024-12-24 11:38:31.49818+00
d3000003-0000-4000-8000-00000000011d	d3000002-0000-4000-8000-000000000099	Opp 153-1	173500	Closed Won	2024-12-21 11:38:31.49818+00	2024-12-21 11:38:31.49818+00
d3000003-0000-4000-8000-00000000011f	d3000002-0000-4000-8000-00000000009a	Opp 154-1	174500	Closed Won	2024-12-18 11:38:31.49818+00	2024-12-18 11:38:31.49818+00
d3000003-0000-4000-8000-000000000121	d3000002-0000-4000-8000-00000000009b	Opp 155-1	175500	Closed Lost	2024-12-15 11:38:31.49818+00	2024-12-15 11:38:31.49818+00
d3000003-0000-4000-8000-000000000123	d3000002-0000-4000-8000-00000000009c	Opp 156-1	176500	Closed Won	2024-12-12 11:38:31.49818+00	2024-12-12 11:38:31.49818+00
d3000003-0000-4000-8000-000000000125	d3000002-0000-4000-8000-00000000009d	Opp 157-1	177500	Closed Won	2024-12-09 11:38:31.49818+00	2024-12-09 11:38:31.49818+00
d3000003-0000-4000-8000-000000000127	d3000002-0000-4000-8000-00000000009e	Opp 158-1	178500	Closed Lost	2024-12-06 11:38:31.49818+00	2024-12-06 11:38:31.49818+00
d3000003-0000-4000-8000-000000000129	d3000002-0000-4000-8000-00000000009f	Opp 159-1	179500	Closed Won	2024-12-03 11:38:31.49818+00	2024-12-03 11:38:31.49818+00
d3000003-0000-4000-8000-00000000012b	d3000002-0000-4000-8000-0000000000a0	Opp 160-1	180500	Closed Won	2024-11-30 11:38:31.49818+00	2024-11-30 11:38:31.49818+00
d3000003-0000-4000-8000-00000000012d	d3000002-0000-4000-8000-0000000000a1	Opp 161-1	181500	Closed Lost	2024-11-27 11:38:31.49818+00	2024-11-27 11:38:31.49818+00
d3000003-0000-4000-8000-00000000012f	d3000002-0000-4000-8000-0000000000a2	Opp 162-1	182500	Closed Won	2024-11-24 11:38:31.49818+00	2024-11-24 11:38:31.49818+00
d3000003-0000-4000-8000-000000000131	d3000002-0000-4000-8000-0000000000a3	Opp 163-1	183500	Closed Won	2024-11-21 11:38:31.49818+00	2024-11-21 11:38:31.49818+00
d3000003-0000-4000-8000-000000000133	d3000002-0000-4000-8000-0000000000a4	Opp 164-1	184500	Closed Lost	2024-11-18 11:38:31.49818+00	2024-11-18 11:38:31.49818+00
d3000003-0000-4000-8000-000000000135	d3000002-0000-4000-8000-0000000000a5	Opp 165-1	185500	Closed Won	2024-11-15 11:38:31.49818+00	2024-11-15 11:38:31.49818+00
d3000003-0000-4000-8000-000000000137	d3000002-0000-4000-8000-0000000000a6	Opp 166-1	186500	Closed Won	2024-11-12 11:38:31.49818+00	2024-11-12 11:38:31.49818+00
d3000003-0000-4000-8000-000000000139	d3000002-0000-4000-8000-0000000000a7	Opp 167-1	187500	Closed Lost	2024-11-09 11:38:31.49818+00	2024-11-09 11:38:31.49818+00
d3000003-0000-4000-8000-00000000013b	d3000002-0000-4000-8000-0000000000a8	Opp 168-1	188500	Closed Won	2024-11-06 11:38:31.49818+00	2024-11-06 11:38:31.49818+00
d3000003-0000-4000-8000-00000000013d	d3000002-0000-4000-8000-0000000000a9	Opp 169-1	189500	Closed Won	2024-11-03 11:38:31.49818+00	2024-11-03 11:38:31.49818+00
d3000003-0000-4000-8000-00000000013f	d3000002-0000-4000-8000-0000000000aa	Opp 170-1	190500	Closed Lost	2024-10-31 11:38:31.49818+00	2024-10-31 11:38:31.49818+00
d3000003-0000-4000-8000-000000000141	d3000002-0000-4000-8000-0000000000ab	Opp 171-1	191500	Closed Won	2024-10-28 11:38:31.49818+00	2024-10-28 11:38:31.49818+00
d3000003-0000-4000-8000-000000000143	d3000002-0000-4000-8000-0000000000ac	Opp 172-1	192500	Closed Won	2024-10-25 11:38:31.49818+00	2024-10-25 11:38:31.49818+00
d3000003-0000-4000-8000-000000000145	d3000002-0000-4000-8000-0000000000ad	Opp 173-1	193500	Closed Lost	2024-10-22 11:38:31.49818+00	2024-10-22 11:38:31.49818+00
d3000003-0000-4000-8000-000000000147	d3000002-0000-4000-8000-0000000000ae	Opp 174-1	194500	Closed Won	2024-10-19 11:38:31.49818+00	2024-10-19 11:38:31.49818+00
d3000003-0000-4000-8000-000000000149	d3000002-0000-4000-8000-0000000000af	Opp 175-1	195500	Closed Won	2024-10-16 11:38:31.49818+00	2024-10-16 11:38:31.49818+00
d3000003-0000-4000-8000-00000000014b	d3000002-0000-4000-8000-0000000000b0	Opp 176-1	196500	Closed Lost	2024-10-13 11:38:31.49818+00	2024-10-13 11:38:31.49818+00
d3000003-0000-4000-8000-00000000014d	d3000002-0000-4000-8000-0000000000b1	Opp 177-1	197500	Closed Won	2024-10-10 11:38:31.49818+00	2024-10-10 11:38:31.49818+00
d3000003-0000-4000-8000-00000000014f	d3000002-0000-4000-8000-0000000000b2	Opp 178-1	198500	Closed Won	2024-10-07 11:38:31.49818+00	2024-10-07 11:38:31.49818+00
d3000003-0000-4000-8000-000000000151	d3000002-0000-4000-8000-0000000000b3	Opp 179-1	199500	Closed Lost	2024-10-04 11:38:31.49818+00	2024-10-04 11:38:31.49818+00
d3000003-0000-4000-8000-000000000153	d3000002-0000-4000-8000-0000000000b4	Opp 180-1	200500	Closed Won	2024-10-01 11:38:31.49818+00	2024-10-01 11:38:31.49818+00
d3000003-0000-4000-8000-000000000155	d3000002-0000-4000-8000-0000000000b5	Opp 181-1	201500	Closed Won	2024-09-28 11:38:31.49818+00	2024-09-28 11:38:31.49818+00
d3000003-0000-4000-8000-000000000157	d3000002-0000-4000-8000-0000000000b6	Opp 182-1	202500	Closed Lost	2024-09-25 11:38:31.49818+00	2024-09-25 11:38:31.49818+00
d3000003-0000-4000-8000-000000000159	d3000002-0000-4000-8000-0000000000b7	Opp 183-1	203500	Closed Won	2024-09-22 11:38:31.49818+00	2024-09-22 11:38:31.49818+00
d3000003-0000-4000-8000-00000000015b	d3000002-0000-4000-8000-0000000000b8	Opp 184-1	204500	Closed Won	2024-09-19 11:38:31.49818+00	2024-09-19 11:38:31.49818+00
d3000003-0000-4000-8000-00000000015d	d3000002-0000-4000-8000-0000000000b9	Opp 185-1	205500	Closed Lost	2024-09-16 11:38:31.49818+00	2024-09-16 11:38:31.49818+00
d3000003-0000-4000-8000-00000000015f	d3000002-0000-4000-8000-0000000000ba	Opp 186-1	206500	Closed Won	2024-09-13 11:38:31.49818+00	2024-09-13 11:38:31.49818+00
d3000003-0000-4000-8000-000000000161	d3000002-0000-4000-8000-0000000000bb	Opp 187-1	207500	Closed Won	2024-09-10 11:38:31.49818+00	2024-09-10 11:38:31.49818+00
d3000003-0000-4000-8000-000000000163	d3000002-0000-4000-8000-0000000000bc	Opp 188-1	208500	Closed Lost	2024-09-07 11:38:31.49818+00	2024-09-07 11:38:31.49818+00
d3000003-0000-4000-8000-000000000165	d3000002-0000-4000-8000-0000000000bd	Opp 189-1	209500	Closed Won	2024-09-04 11:38:31.49818+00	2024-09-04 11:38:31.49818+00
d3000003-0000-4000-8000-000000000167	d3000002-0000-4000-8000-0000000000be	Opp 190-1	210500	Closed Won	2024-09-01 11:38:31.49818+00	2024-09-01 11:38:31.49818+00
d3000003-0000-4000-8000-000000000169	d3000002-0000-4000-8000-0000000000bf	Opp 191-1	211500	Closed Lost	2024-08-29 11:38:31.49818+00	2024-08-29 11:38:31.49818+00
d3000003-0000-4000-8000-00000000016b	d3000002-0000-4000-8000-0000000000c0	Opp 192-1	212500	Closed Won	2024-08-26 11:38:31.49818+00	2024-08-26 11:38:31.49818+00
d3000003-0000-4000-8000-00000000016d	d3000002-0000-4000-8000-0000000000c1	Opp 193-1	213500	Closed Won	2024-08-23 11:38:31.49818+00	2024-08-23 11:38:31.49818+00
d3000003-0000-4000-8000-00000000016f	d3000002-0000-4000-8000-0000000000c2	Opp 194-1	214500	Closed Lost	2024-08-20 11:38:31.49818+00	2024-08-20 11:38:31.49818+00
d3000003-0000-4000-8000-000000000171	d3000002-0000-4000-8000-0000000000c3	Opp 195-1	215500	Closed Won	2024-08-17 11:38:31.49818+00	2024-08-17 11:38:31.49818+00
d3000003-0000-4000-8000-000000000173	d3000002-0000-4000-8000-0000000000c4	Opp 196-1	216500	Closed Won	2024-08-14 11:38:31.49818+00	2024-08-14 11:38:31.49818+00
d3000003-0000-4000-8000-000000000175	d3000002-0000-4000-8000-0000000000c5	Opp 197-1	217500	Closed Lost	2024-08-11 11:38:31.49818+00	2024-08-11 11:38:31.49818+00
d3000003-0000-4000-8000-000000000177	d3000002-0000-4000-8000-0000000000c6	Opp 198-1	218500	Closed Won	2024-08-08 11:38:31.49818+00	2024-08-08 11:38:31.49818+00
d3000003-0000-4000-8000-000000000179	d3000002-0000-4000-8000-0000000000c7	Opp 199-1	219500	Closed Won	2024-08-05 11:38:31.49818+00	2024-08-05 11:38:31.49818+00
d3000003-0000-4000-8000-00000000017b	d3000002-0000-4000-8000-0000000000c8	Opp 200-1	220500	Closed Lost	2024-08-02 11:38:31.49818+00	2024-08-02 11:38:31.49818+00
d3000003-0000-4000-8000-00000000017d	d3000002-0000-4000-8000-0000000000c9	Opp 201-1	221500	Closed Won	2024-07-30 11:38:31.49818+00	2024-07-30 11:38:31.49818+00
d3000003-0000-4000-8000-00000000017f	d3000002-0000-4000-8000-0000000000ca	Opp 202-1	222500	Closed Won	2024-07-27 11:38:31.49818+00	2024-07-27 11:38:31.49818+00
d3000003-0000-4000-8000-000000000181	d3000002-0000-4000-8000-0000000000cb	Opp 203-1	223500	Closed Lost	2024-07-24 11:38:31.49818+00	2024-07-24 11:38:31.49818+00
d3000003-0000-4000-8000-000000000183	d3000002-0000-4000-8000-0000000000cc	Opp 204-1	224500	Closed Won	2024-07-21 11:38:31.49818+00	2024-07-21 11:38:31.49818+00
d3000003-0000-4000-8000-000000000185	d3000002-0000-4000-8000-0000000000cd	Opp 205-1	225500	Closed Won	2024-07-18 11:38:31.49818+00	2024-07-18 11:38:31.49818+00
d3000003-0000-4000-8000-000000000187	d3000002-0000-4000-8000-0000000000ce	Opp 206-1	226500	Closed Lost	2024-07-15 11:38:31.49818+00	2024-07-15 11:38:31.49818+00
d3000003-0000-4000-8000-000000000189	d3000002-0000-4000-8000-0000000000cf	Opp 207-1	227500	Closed Won	2024-07-12 11:38:31.49818+00	2024-07-12 11:38:31.49818+00
d3000003-0000-4000-8000-00000000018b	d3000002-0000-4000-8000-0000000000d0	Opp 208-1	228500	Closed Won	2024-07-09 11:38:31.49818+00	2024-07-09 11:38:31.49818+00
d3000003-0000-4000-8000-00000000018d	d3000002-0000-4000-8000-0000000000d1	Opp 209-1	229500	Closed Lost	2024-07-06 11:38:31.49818+00	2024-07-06 11:38:31.49818+00
d3000003-0000-4000-8000-00000000018f	d3000002-0000-4000-8000-0000000000d2	Opp 210-1	30500	Closed Won	2024-07-03 11:38:31.49818+00	2024-07-03 11:38:31.49818+00
d3000003-0000-4000-8000-000000000002	d3000002-0000-4000-8000-00000000000b	Opp 11-2	32000	Closed Won	2026-02-18 11:38:31.49818+00	2026-02-18 11:38:31.49818+00
d3000003-0000-4000-8000-000000000004	d3000002-0000-4000-8000-00000000000c	Opp 12-2	33000	Closed Won	2026-02-15 11:38:31.49818+00	2026-02-15 11:38:31.49818+00
d3000003-0000-4000-8000-000000000006	d3000002-0000-4000-8000-00000000000d	Opp 13-2	34000	Closed Lost	2026-02-12 11:38:31.49818+00	2026-02-12 11:38:31.49818+00
d3000003-0000-4000-8000-000000000008	d3000002-0000-4000-8000-00000000000e	Opp 14-2	35000	Closed Won	2026-02-09 11:38:31.49818+00	2026-02-09 11:38:31.49818+00
d3000003-0000-4000-8000-00000000000a	d3000002-0000-4000-8000-00000000000f	Opp 15-2	36000	Closed Won	2026-02-06 11:38:31.49818+00	2026-02-06 11:38:31.49818+00
d3000003-0000-4000-8000-00000000000c	d3000002-0000-4000-8000-000000000010	Opp 16-2	37000	Closed Lost	2026-02-03 11:38:31.49818+00	2026-02-03 11:38:31.49818+00
d3000003-0000-4000-8000-00000000000e	d3000002-0000-4000-8000-000000000011	Opp 17-2	38000	Closed Won	2026-01-31 11:38:31.49818+00	2026-01-31 11:38:31.49818+00
d3000003-0000-4000-8000-000000000010	d3000002-0000-4000-8000-000000000012	Opp 18-2	39000	Closed Won	2026-01-28 11:38:31.49818+00	2026-01-28 11:38:31.49818+00
d3000003-0000-4000-8000-000000000012	d3000002-0000-4000-8000-000000000013	Opp 19-2	40000	Closed Lost	2026-01-25 11:38:31.49818+00	2026-01-25 11:38:31.49818+00
d3000003-0000-4000-8000-000000000014	d3000002-0000-4000-8000-000000000014	Opp 20-2	41000	Closed Won	2026-01-22 11:38:31.49818+00	2026-01-22 11:38:31.49818+00
d3000003-0000-4000-8000-000000000016	d3000002-0000-4000-8000-000000000015	Opp 21-2	42000	Closed Won	2026-01-19 11:38:31.49818+00	2026-01-19 11:38:31.49818+00
d3000003-0000-4000-8000-000000000018	d3000002-0000-4000-8000-000000000016	Opp 22-2	43000	Closed Lost	2026-01-16 11:38:31.49818+00	2026-01-16 11:38:31.49818+00
d3000003-0000-4000-8000-00000000001a	d3000002-0000-4000-8000-000000000017	Opp 23-2	44000	Closed Won	2026-01-13 11:38:31.49818+00	2026-01-13 11:38:31.49818+00
d3000003-0000-4000-8000-00000000001c	d3000002-0000-4000-8000-000000000018	Opp 24-2	45000	Closed Won	2026-01-10 11:38:31.49818+00	2026-01-10 11:38:31.49818+00
d3000003-0000-4000-8000-00000000001e	d3000002-0000-4000-8000-000000000019	Opp 25-2	46000	Closed Lost	2026-01-07 11:38:31.49818+00	2026-01-07 11:38:31.49818+00
d3000003-0000-4000-8000-000000000020	d3000002-0000-4000-8000-00000000001a	Opp 26-2	47000	Closed Won	2026-01-04 11:38:31.49818+00	2026-01-04 11:38:31.49818+00
d3000003-0000-4000-8000-000000000022	d3000002-0000-4000-8000-00000000001b	Opp 27-2	48000	Closed Won	2026-01-01 11:38:31.49818+00	2026-01-01 11:38:31.49818+00
d3000003-0000-4000-8000-000000000024	d3000002-0000-4000-8000-00000000001c	Opp 28-2	49000	Closed Lost	2025-12-29 11:38:31.49818+00	2025-12-29 11:38:31.49818+00
d3000003-0000-4000-8000-000000000026	d3000002-0000-4000-8000-00000000001d	Opp 29-2	50000	Closed Won	2025-12-26 11:38:31.49818+00	2025-12-26 11:38:31.49818+00
d3000003-0000-4000-8000-000000000028	d3000002-0000-4000-8000-00000000001e	Opp 30-2	51000	Closed Won	2025-12-23 11:38:31.49818+00	2025-12-23 11:38:31.49818+00
d3000003-0000-4000-8000-00000000002a	d3000002-0000-4000-8000-00000000001f	Opp 31-2	52000	Closed Lost	2025-12-20 11:38:31.49818+00	2025-12-20 11:38:31.49818+00
d3000003-0000-4000-8000-00000000002c	d3000002-0000-4000-8000-000000000020	Opp 32-2	53000	Closed Won	2025-12-17 11:38:31.49818+00	2025-12-17 11:38:31.49818+00
d3000003-0000-4000-8000-00000000002e	d3000002-0000-4000-8000-000000000021	Opp 33-2	54000	Closed Won	2025-12-14 11:38:31.49818+00	2025-12-14 11:38:31.49818+00
d3000003-0000-4000-8000-000000000030	d3000002-0000-4000-8000-000000000022	Opp 34-2	55000	Closed Lost	2025-12-11 11:38:31.49818+00	2025-12-11 11:38:31.49818+00
d3000003-0000-4000-8000-000000000032	d3000002-0000-4000-8000-000000000023	Opp 35-2	56000	Closed Won	2025-12-08 11:38:31.49818+00	2025-12-08 11:38:31.49818+00
d3000003-0000-4000-8000-000000000034	d3000002-0000-4000-8000-000000000024	Opp 36-2	57000	Closed Won	2025-12-05 11:38:31.49818+00	2025-12-05 11:38:31.49818+00
d3000003-0000-4000-8000-000000000036	d3000002-0000-4000-8000-000000000025	Opp 37-2	58000	Closed Lost	2025-12-02 11:38:31.49818+00	2025-12-02 11:38:31.49818+00
d3000003-0000-4000-8000-000000000038	d3000002-0000-4000-8000-000000000026	Opp 38-2	59000	Closed Won	2025-11-29 11:38:31.49818+00	2025-11-29 11:38:31.49818+00
d3000003-0000-4000-8000-00000000003a	d3000002-0000-4000-8000-000000000027	Opp 39-2	60000	Closed Won	2025-11-26 11:38:31.49818+00	2025-11-26 11:38:31.49818+00
d3000003-0000-4000-8000-00000000003c	d3000002-0000-4000-8000-000000000028	Opp 40-2	61000	Closed Lost	2025-11-23 11:38:31.49818+00	2025-11-23 11:38:31.49818+00
d3000003-0000-4000-8000-00000000003e	d3000002-0000-4000-8000-000000000029	Opp 41-2	62000	Closed Won	2025-11-20 11:38:31.49818+00	2025-11-20 11:38:31.49818+00
d3000003-0000-4000-8000-000000000040	d3000002-0000-4000-8000-00000000002a	Opp 42-2	63000	Closed Won	2025-11-17 11:38:31.49818+00	2025-11-17 11:38:31.49818+00
d3000003-0000-4000-8000-000000000042	d3000002-0000-4000-8000-00000000002b	Opp 43-2	64000	Closed Lost	2025-11-14 11:38:31.49818+00	2025-11-14 11:38:31.49818+00
d3000003-0000-4000-8000-000000000044	d3000002-0000-4000-8000-00000000002c	Opp 44-2	65000	Closed Won	2025-11-11 11:38:31.49818+00	2025-11-11 11:38:31.49818+00
d3000003-0000-4000-8000-000000000046	d3000002-0000-4000-8000-00000000002d	Opp 45-2	66000	Closed Won	2025-11-08 11:38:31.49818+00	2025-11-08 11:38:31.49818+00
d3000003-0000-4000-8000-000000000048	d3000002-0000-4000-8000-00000000002e	Opp 46-2	67000	Closed Lost	2025-11-05 11:38:31.49818+00	2025-11-05 11:38:31.49818+00
d3000003-0000-4000-8000-00000000004a	d3000002-0000-4000-8000-00000000002f	Opp 47-2	68000	Closed Won	2025-11-02 11:38:31.49818+00	2025-11-02 11:38:31.49818+00
d3000003-0000-4000-8000-00000000004c	d3000002-0000-4000-8000-000000000030	Opp 48-2	69000	Closed Won	2025-10-30 11:38:31.49818+00	2025-10-30 11:38:31.49818+00
d3000003-0000-4000-8000-00000000004e	d3000002-0000-4000-8000-000000000031	Opp 49-2	70000	Closed Lost	2025-10-27 11:38:31.49818+00	2025-10-27 11:38:31.49818+00
d3000003-0000-4000-8000-000000000050	d3000002-0000-4000-8000-000000000032	Opp 50-2	71000	Closed Won	2025-10-24 11:38:31.49818+00	2025-10-24 11:38:31.49818+00
d3000003-0000-4000-8000-000000000052	d3000002-0000-4000-8000-000000000033	Opp 51-2	72000	Closed Won	2025-10-21 11:38:31.49818+00	2025-10-21 11:38:31.49818+00
d3000003-0000-4000-8000-000000000054	d3000002-0000-4000-8000-000000000034	Opp 52-2	73000	Closed Lost	2025-10-18 11:38:31.49818+00	2025-10-18 11:38:31.49818+00
d3000003-0000-4000-8000-000000000056	d3000002-0000-4000-8000-000000000035	Opp 53-2	74000	Closed Won	2025-10-15 11:38:31.49818+00	2025-10-15 11:38:31.49818+00
d3000003-0000-4000-8000-000000000058	d3000002-0000-4000-8000-000000000036	Opp 54-2	75000	Closed Won	2025-10-12 11:38:31.49818+00	2025-10-12 11:38:31.49818+00
d3000003-0000-4000-8000-00000000005a	d3000002-0000-4000-8000-000000000037	Opp 55-2	76000	Closed Lost	2025-10-09 11:38:31.49818+00	2025-10-09 11:38:31.49818+00
d3000003-0000-4000-8000-00000000005c	d3000002-0000-4000-8000-000000000038	Opp 56-2	77000	Closed Won	2025-10-06 11:38:31.49818+00	2025-10-06 11:38:31.49818+00
d3000003-0000-4000-8000-00000000005e	d3000002-0000-4000-8000-000000000039	Opp 57-2	78000	Closed Won	2025-10-03 11:38:31.49818+00	2025-10-03 11:38:31.49818+00
d3000003-0000-4000-8000-000000000060	d3000002-0000-4000-8000-00000000003a	Opp 58-2	79000	Closed Lost	2025-09-30 11:38:31.49818+00	2025-09-30 11:38:31.49818+00
d3000003-0000-4000-8000-000000000062	d3000002-0000-4000-8000-00000000003b	Opp 59-2	80000	Closed Won	2025-09-27 11:38:31.49818+00	2025-09-27 11:38:31.49818+00
d3000003-0000-4000-8000-000000000064	d3000002-0000-4000-8000-00000000003c	Opp 60-2	81000	Closed Won	2025-09-24 11:38:31.49818+00	2025-09-24 11:38:31.49818+00
d3000003-0000-4000-8000-000000000066	d3000002-0000-4000-8000-00000000003d	Opp 61-2	82000	Closed Lost	2025-09-21 11:38:31.49818+00	2025-09-21 11:38:31.49818+00
d3000003-0000-4000-8000-000000000068	d3000002-0000-4000-8000-00000000003e	Opp 62-2	83000	Closed Won	2025-09-18 11:38:31.49818+00	2025-09-18 11:38:31.49818+00
d3000003-0000-4000-8000-00000000006a	d3000002-0000-4000-8000-00000000003f	Opp 63-2	84000	Closed Won	2025-09-15 11:38:31.49818+00	2025-09-15 11:38:31.49818+00
d3000003-0000-4000-8000-00000000006c	d3000002-0000-4000-8000-000000000040	Opp 64-2	85000	Closed Lost	2025-09-12 11:38:31.49818+00	2025-09-12 11:38:31.49818+00
d3000003-0000-4000-8000-00000000006e	d3000002-0000-4000-8000-000000000041	Opp 65-2	86000	Closed Won	2025-09-09 11:38:31.49818+00	2025-09-09 11:38:31.49818+00
d3000003-0000-4000-8000-000000000070	d3000002-0000-4000-8000-000000000042	Opp 66-2	87000	Closed Won	2025-09-06 11:38:31.49818+00	2025-09-06 11:38:31.49818+00
d3000003-0000-4000-8000-000000000072	d3000002-0000-4000-8000-000000000043	Opp 67-2	88000	Closed Lost	2025-09-03 11:38:31.49818+00	2025-09-03 11:38:31.49818+00
d3000003-0000-4000-8000-000000000074	d3000002-0000-4000-8000-000000000044	Opp 68-2	89000	Closed Won	2025-08-31 11:38:31.49818+00	2025-08-31 11:38:31.49818+00
d3000003-0000-4000-8000-000000000076	d3000002-0000-4000-8000-000000000045	Opp 69-2	90000	Closed Won	2025-08-28 11:38:31.49818+00	2025-08-28 11:38:31.49818+00
d3000003-0000-4000-8000-000000000078	d3000002-0000-4000-8000-000000000046	Opp 70-2	91000	Closed Lost	2025-08-25 11:38:31.49818+00	2025-08-25 11:38:31.49818+00
d3000003-0000-4000-8000-00000000007a	d3000002-0000-4000-8000-000000000047	Opp 71-2	92000	Closed Won	2025-08-22 11:38:31.49818+00	2025-08-22 11:38:31.49818+00
d3000003-0000-4000-8000-00000000007c	d3000002-0000-4000-8000-000000000048	Opp 72-2	93000	Closed Won	2025-08-19 11:38:31.49818+00	2025-08-19 11:38:31.49818+00
d3000003-0000-4000-8000-00000000007e	d3000002-0000-4000-8000-000000000049	Opp 73-2	94000	Closed Lost	2025-08-16 11:38:31.49818+00	2025-08-16 11:38:31.49818+00
d3000003-0000-4000-8000-000000000080	d3000002-0000-4000-8000-00000000004a	Opp 74-2	95000	Closed Won	2025-08-13 11:38:31.49818+00	2025-08-13 11:38:31.49818+00
d3000003-0000-4000-8000-000000000082	d3000002-0000-4000-8000-00000000004b	Opp 75-2	96000	Closed Won	2025-08-10 11:38:31.49818+00	2025-08-10 11:38:31.49818+00
d3000003-0000-4000-8000-000000000084	d3000002-0000-4000-8000-00000000004c	Opp 76-2	97000	Closed Lost	2025-08-07 11:38:31.49818+00	2025-08-07 11:38:31.49818+00
d3000003-0000-4000-8000-000000000086	d3000002-0000-4000-8000-00000000004d	Opp 77-2	98000	Closed Won	2025-08-04 11:38:31.49818+00	2025-08-04 11:38:31.49818+00
d3000003-0000-4000-8000-000000000088	d3000002-0000-4000-8000-00000000004e	Opp 78-2	99000	Closed Won	2025-08-01 11:38:31.49818+00	2025-08-01 11:38:31.49818+00
d3000003-0000-4000-8000-00000000008a	d3000002-0000-4000-8000-00000000004f	Opp 79-2	100000	Closed Lost	2025-07-29 11:38:31.49818+00	2025-07-29 11:38:31.49818+00
d3000003-0000-4000-8000-00000000008c	d3000002-0000-4000-8000-000000000050	Opp 80-2	101000	Closed Won	2025-07-26 11:38:31.49818+00	2025-07-26 11:38:31.49818+00
d3000003-0000-4000-8000-00000000008e	d3000002-0000-4000-8000-000000000051	Opp 81-2	102000	Closed Won	2025-07-23 11:38:31.49818+00	2025-07-23 11:38:31.49818+00
d3000003-0000-4000-8000-000000000090	d3000002-0000-4000-8000-000000000052	Opp 82-2	103000	Closed Lost	2025-07-20 11:38:31.49818+00	2025-07-20 11:38:31.49818+00
d3000003-0000-4000-8000-000000000092	d3000002-0000-4000-8000-000000000053	Opp 83-2	104000	Closed Won	2025-07-17 11:38:31.49818+00	2025-07-17 11:38:31.49818+00
d3000003-0000-4000-8000-000000000094	d3000002-0000-4000-8000-000000000054	Opp 84-2	105000	Closed Won	2025-07-14 11:38:31.49818+00	2025-07-14 11:38:31.49818+00
d3000003-0000-4000-8000-000000000096	d3000002-0000-4000-8000-000000000055	Opp 85-2	106000	Closed Lost	2025-07-11 11:38:31.49818+00	2025-07-11 11:38:31.49818+00
d3000003-0000-4000-8000-000000000098	d3000002-0000-4000-8000-000000000056	Opp 86-2	107000	Closed Won	2025-07-08 11:38:31.49818+00	2025-07-08 11:38:31.49818+00
d3000003-0000-4000-8000-00000000009a	d3000002-0000-4000-8000-000000000057	Opp 87-2	108000	Closed Won	2025-07-05 11:38:31.49818+00	2025-07-05 11:38:31.49818+00
d3000003-0000-4000-8000-00000000009c	d3000002-0000-4000-8000-000000000058	Opp 88-2	109000	Closed Lost	2025-07-02 11:38:31.49818+00	2025-07-02 11:38:31.49818+00
d3000003-0000-4000-8000-00000000009e	d3000002-0000-4000-8000-000000000059	Opp 89-2	110000	Closed Won	2025-06-29 11:38:31.49818+00	2025-06-29 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a0	d3000002-0000-4000-8000-00000000005a	Opp 90-2	111000	Closed Won	2025-06-26 11:38:31.49818+00	2025-06-26 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a2	d3000002-0000-4000-8000-00000000005b	Opp 91-2	112000	Closed Lost	2025-06-23 11:38:31.49818+00	2025-06-23 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a4	d3000002-0000-4000-8000-00000000005c	Opp 92-2	113000	Closed Won	2025-06-20 11:38:31.49818+00	2025-06-20 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a6	d3000002-0000-4000-8000-00000000005d	Opp 93-2	114000	Closed Won	2025-06-17 11:38:31.49818+00	2025-06-17 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000a8	d3000002-0000-4000-8000-00000000005e	Opp 94-2	115000	Closed Lost	2025-06-14 11:38:31.49818+00	2025-06-14 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000aa	d3000002-0000-4000-8000-00000000005f	Opp 95-2	116000	Closed Won	2025-06-11 11:38:31.49818+00	2025-06-11 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ac	d3000002-0000-4000-8000-000000000060	Opp 96-2	117000	Closed Won	2025-06-08 11:38:31.49818+00	2025-06-08 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ae	d3000002-0000-4000-8000-000000000061	Opp 97-2	118000	Closed Lost	2025-06-05 11:38:31.49818+00	2025-06-05 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b0	d3000002-0000-4000-8000-000000000062	Opp 98-2	119000	Closed Won	2025-06-02 11:38:31.49818+00	2025-06-02 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b2	d3000002-0000-4000-8000-000000000063	Opp 99-2	120000	Closed Won	2025-05-30 11:38:31.49818+00	2025-05-30 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b4	d3000002-0000-4000-8000-000000000064	Opp 100-2	121000	Closed Lost	2025-05-27 11:38:31.49818+00	2025-05-27 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b6	d3000002-0000-4000-8000-000000000065	Opp 101-2	122000	Closed Won	2025-05-24 11:38:31.49818+00	2025-05-24 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000b8	d3000002-0000-4000-8000-000000000066	Opp 102-2	123000	Closed Won	2025-05-21 11:38:31.49818+00	2025-05-21 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ba	d3000002-0000-4000-8000-000000000067	Opp 103-2	124000	Closed Lost	2025-05-18 11:38:31.49818+00	2025-05-18 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000bc	d3000002-0000-4000-8000-000000000068	Opp 104-2	125000	Closed Won	2025-05-15 11:38:31.49818+00	2025-05-15 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000be	d3000002-0000-4000-8000-000000000069	Opp 105-2	126000	Closed Won	2025-05-12 11:38:31.49818+00	2025-05-12 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c0	d3000002-0000-4000-8000-00000000006a	Opp 106-2	127000	Closed Lost	2025-05-09 11:38:31.49818+00	2025-05-09 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c2	d3000002-0000-4000-8000-00000000006b	Opp 107-2	128000	Closed Won	2025-05-06 11:38:31.49818+00	2025-05-06 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c4	d3000002-0000-4000-8000-00000000006c	Opp 108-2	129000	Closed Won	2025-05-03 11:38:31.49818+00	2025-05-03 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c6	d3000002-0000-4000-8000-00000000006d	Opp 109-2	130000	Closed Lost	2025-04-30 11:38:31.49818+00	2025-04-30 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000c8	d3000002-0000-4000-8000-00000000006e	Opp 110-2	131000	Closed Won	2025-04-27 11:38:31.49818+00	2025-04-27 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ca	d3000002-0000-4000-8000-00000000006f	Opp 111-2	132000	Closed Won	2025-04-24 11:38:31.49818+00	2025-04-24 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000cc	d3000002-0000-4000-8000-000000000070	Opp 112-2	133000	Closed Lost	2025-04-21 11:38:31.49818+00	2025-04-21 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ce	d3000002-0000-4000-8000-000000000071	Opp 113-2	134000	Closed Won	2025-04-18 11:38:31.49818+00	2025-04-18 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d0	d3000002-0000-4000-8000-000000000072	Opp 114-2	135000	Closed Won	2025-04-15 11:38:31.49818+00	2025-04-15 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d2	d3000002-0000-4000-8000-000000000073	Opp 115-2	136000	Closed Lost	2025-04-12 11:38:31.49818+00	2025-04-12 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d4	d3000002-0000-4000-8000-000000000074	Opp 116-2	137000	Closed Won	2025-04-09 11:38:31.49818+00	2025-04-09 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d6	d3000002-0000-4000-8000-000000000075	Opp 117-2	138000	Closed Won	2025-04-06 11:38:31.49818+00	2025-04-06 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000d8	d3000002-0000-4000-8000-000000000076	Opp 118-2	139000	Closed Lost	2025-04-03 11:38:31.49818+00	2025-04-03 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000da	d3000002-0000-4000-8000-000000000077	Opp 119-2	140000	Closed Won	2025-03-31 11:38:31.49818+00	2025-03-31 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000dc	d3000002-0000-4000-8000-000000000078	Opp 120-2	141000	Closed Won	2025-03-28 11:38:31.49818+00	2025-03-28 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000de	d3000002-0000-4000-8000-000000000079	Opp 121-2	142000	Closed Lost	2025-03-25 11:38:31.49818+00	2025-03-25 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e0	d3000002-0000-4000-8000-00000000007a	Opp 122-2	143000	Closed Won	2025-03-22 11:38:31.49818+00	2025-03-22 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e2	d3000002-0000-4000-8000-00000000007b	Opp 123-2	144000	Closed Won	2025-03-19 11:38:31.49818+00	2025-03-19 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e4	d3000002-0000-4000-8000-00000000007c	Opp 124-2	145000	Closed Lost	2025-03-16 11:38:31.49818+00	2025-03-16 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e6	d3000002-0000-4000-8000-00000000007d	Opp 125-2	146000	Closed Won	2025-03-13 11:38:31.49818+00	2025-03-13 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000e8	d3000002-0000-4000-8000-00000000007e	Opp 126-2	147000	Closed Won	2025-03-10 11:38:31.49818+00	2025-03-10 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ea	d3000002-0000-4000-8000-00000000007f	Opp 127-2	148000	Closed Lost	2025-03-07 11:38:31.49818+00	2025-03-07 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ec	d3000002-0000-4000-8000-000000000080	Opp 128-2	149000	Closed Won	2025-03-04 11:38:31.49818+00	2025-03-04 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000ee	d3000002-0000-4000-8000-000000000081	Opp 129-2	150000	Closed Won	2025-03-01 11:38:31.49818+00	2025-03-01 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f0	d3000002-0000-4000-8000-000000000082	Opp 130-2	151000	Closed Lost	2025-02-26 11:38:31.49818+00	2025-02-26 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f2	d3000002-0000-4000-8000-000000000083	Opp 131-2	152000	Closed Won	2025-02-23 11:38:31.49818+00	2025-02-23 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f4	d3000002-0000-4000-8000-000000000084	Opp 132-2	153000	Closed Won	2025-02-20 11:38:31.49818+00	2025-02-20 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f6	d3000002-0000-4000-8000-000000000085	Opp 133-2	154000	Closed Lost	2025-02-17 11:38:31.49818+00	2025-02-17 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000f8	d3000002-0000-4000-8000-000000000086	Opp 134-2	155000	Closed Won	2025-02-14 11:38:31.49818+00	2025-02-14 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000fa	d3000002-0000-4000-8000-000000000087	Opp 135-2	156000	Closed Won	2025-02-11 11:38:31.49818+00	2025-02-11 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000fc	d3000002-0000-4000-8000-000000000088	Opp 136-2	157000	Closed Lost	2025-02-08 11:38:31.49818+00	2025-02-08 11:38:31.49818+00
d3000003-0000-4000-8000-0000000000fe	d3000002-0000-4000-8000-000000000089	Opp 137-2	158000	Closed Won	2025-02-05 11:38:31.49818+00	2025-02-05 11:38:31.49818+00
d3000003-0000-4000-8000-000000000100	d3000002-0000-4000-8000-00000000008a	Opp 138-2	159000	Closed Won	2025-02-02 11:38:31.49818+00	2025-02-02 11:38:31.49818+00
d3000003-0000-4000-8000-000000000102	d3000002-0000-4000-8000-00000000008b	Opp 139-2	160000	Closed Lost	2025-01-30 11:38:31.49818+00	2025-01-30 11:38:31.49818+00
d3000003-0000-4000-8000-000000000104	d3000002-0000-4000-8000-00000000008c	Opp 140-2	161000	Closed Won	2025-01-27 11:38:31.49818+00	2025-01-27 11:38:31.49818+00
d3000003-0000-4000-8000-000000000106	d3000002-0000-4000-8000-00000000008d	Opp 141-2	162000	Closed Won	2025-01-24 11:38:31.49818+00	2025-01-24 11:38:31.49818+00
d3000003-0000-4000-8000-000000000108	d3000002-0000-4000-8000-00000000008e	Opp 142-2	163000	Closed Lost	2025-01-21 11:38:31.49818+00	2025-01-21 11:38:31.49818+00
d3000003-0000-4000-8000-00000000010a	d3000002-0000-4000-8000-00000000008f	Opp 143-2	164000	Closed Won	2025-01-18 11:38:31.49818+00	2025-01-18 11:38:31.49818+00
d3000003-0000-4000-8000-00000000010c	d3000002-0000-4000-8000-000000000090	Opp 144-2	165000	Closed Won	2025-01-15 11:38:31.49818+00	2025-01-15 11:38:31.49818+00
d3000003-0000-4000-8000-00000000010e	d3000002-0000-4000-8000-000000000091	Opp 145-2	166000	Closed Lost	2025-01-12 11:38:31.49818+00	2025-01-12 11:38:31.49818+00
d3000003-0000-4000-8000-000000000110	d3000002-0000-4000-8000-000000000092	Opp 146-2	167000	Closed Won	2025-01-09 11:38:31.49818+00	2025-01-09 11:38:31.49818+00
d3000003-0000-4000-8000-000000000112	d3000002-0000-4000-8000-000000000093	Opp 147-2	168000	Closed Won	2025-01-06 11:38:31.49818+00	2025-01-06 11:38:31.49818+00
d3000003-0000-4000-8000-000000000114	d3000002-0000-4000-8000-000000000094	Opp 148-2	169000	Closed Lost	2025-01-03 11:38:31.49818+00	2025-01-03 11:38:31.49818+00
d3000003-0000-4000-8000-000000000116	d3000002-0000-4000-8000-000000000095	Opp 149-2	170000	Closed Won	2024-12-31 11:38:31.49818+00	2024-12-31 11:38:31.49818+00
d3000003-0000-4000-8000-000000000118	d3000002-0000-4000-8000-000000000096	Opp 150-2	171000	Closed Won	2024-12-28 11:38:31.49818+00	2024-12-28 11:38:31.49818+00
d3000003-0000-4000-8000-00000000011a	d3000002-0000-4000-8000-000000000097	Opp 151-2	172000	Closed Lost	2024-12-25 11:38:31.49818+00	2024-12-25 11:38:31.49818+00
d3000003-0000-4000-8000-00000000011c	d3000002-0000-4000-8000-000000000098	Opp 152-2	173000	Closed Won	2024-12-22 11:38:31.49818+00	2024-12-22 11:38:31.49818+00
d3000003-0000-4000-8000-00000000011e	d3000002-0000-4000-8000-000000000099	Opp 153-2	174000	Closed Won	2024-12-19 11:38:31.49818+00	2024-12-19 11:38:31.49818+00
d3000003-0000-4000-8000-000000000120	d3000002-0000-4000-8000-00000000009a	Opp 154-2	175000	Closed Lost	2024-12-16 11:38:31.49818+00	2024-12-16 11:38:31.49818+00
d3000003-0000-4000-8000-000000000122	d3000002-0000-4000-8000-00000000009b	Opp 155-2	176000	Closed Won	2024-12-13 11:38:31.49818+00	2024-12-13 11:38:31.49818+00
d3000003-0000-4000-8000-000000000124	d3000002-0000-4000-8000-00000000009c	Opp 156-2	177000	Closed Won	2024-12-10 11:38:31.49818+00	2024-12-10 11:38:31.49818+00
d3000003-0000-4000-8000-000000000126	d3000002-0000-4000-8000-00000000009d	Opp 157-2	178000	Closed Lost	2024-12-07 11:38:31.49818+00	2024-12-07 11:38:31.49818+00
d3000003-0000-4000-8000-000000000128	d3000002-0000-4000-8000-00000000009e	Opp 158-2	179000	Closed Won	2024-12-04 11:38:31.49818+00	2024-12-04 11:38:31.49818+00
d3000003-0000-4000-8000-00000000012a	d3000002-0000-4000-8000-00000000009f	Opp 159-2	180000	Closed Won	2024-12-01 11:38:31.49818+00	2024-12-01 11:38:31.49818+00
d3000003-0000-4000-8000-00000000012c	d3000002-0000-4000-8000-0000000000a0	Opp 160-2	181000	Closed Lost	2024-11-28 11:38:31.49818+00	2024-11-28 11:38:31.49818+00
d3000003-0000-4000-8000-00000000012e	d3000002-0000-4000-8000-0000000000a1	Opp 161-2	182000	Closed Won	2024-11-25 11:38:31.49818+00	2024-11-25 11:38:31.49818+00
d3000003-0000-4000-8000-000000000130	d3000002-0000-4000-8000-0000000000a2	Opp 162-2	183000	Closed Won	2024-11-22 11:38:31.49818+00	2024-11-22 11:38:31.49818+00
d3000003-0000-4000-8000-000000000132	d3000002-0000-4000-8000-0000000000a3	Opp 163-2	184000	Closed Lost	2024-11-19 11:38:31.49818+00	2024-11-19 11:38:31.49818+00
d3000003-0000-4000-8000-000000000134	d3000002-0000-4000-8000-0000000000a4	Opp 164-2	185000	Closed Won	2024-11-16 11:38:31.49818+00	2024-11-16 11:38:31.49818+00
d3000003-0000-4000-8000-000000000136	d3000002-0000-4000-8000-0000000000a5	Opp 165-2	186000	Closed Won	2024-11-13 11:38:31.49818+00	2024-11-13 11:38:31.49818+00
d3000003-0000-4000-8000-000000000138	d3000002-0000-4000-8000-0000000000a6	Opp 166-2	187000	Closed Lost	2024-11-10 11:38:31.49818+00	2024-11-10 11:38:31.49818+00
d3000003-0000-4000-8000-00000000013a	d3000002-0000-4000-8000-0000000000a7	Opp 167-2	188000	Closed Won	2024-11-07 11:38:31.49818+00	2024-11-07 11:38:31.49818+00
d3000003-0000-4000-8000-00000000013c	d3000002-0000-4000-8000-0000000000a8	Opp 168-2	189000	Closed Won	2024-11-04 11:38:31.49818+00	2024-11-04 11:38:31.49818+00
d3000003-0000-4000-8000-00000000013e	d3000002-0000-4000-8000-0000000000a9	Opp 169-2	190000	Closed Lost	2024-11-01 11:38:31.49818+00	2024-11-01 11:38:31.49818+00
d3000003-0000-4000-8000-000000000140	d3000002-0000-4000-8000-0000000000aa	Opp 170-2	191000	Closed Won	2024-10-29 11:38:31.49818+00	2024-10-29 11:38:31.49818+00
d3000003-0000-4000-8000-000000000142	d3000002-0000-4000-8000-0000000000ab	Opp 171-2	192000	Closed Won	2024-10-26 11:38:31.49818+00	2024-10-26 11:38:31.49818+00
d3000003-0000-4000-8000-000000000144	d3000002-0000-4000-8000-0000000000ac	Opp 172-2	193000	Closed Lost	2024-10-23 11:38:31.49818+00	2024-10-23 11:38:31.49818+00
d3000003-0000-4000-8000-000000000146	d3000002-0000-4000-8000-0000000000ad	Opp 173-2	194000	Closed Won	2024-10-20 11:38:31.49818+00	2024-10-20 11:38:31.49818+00
d3000003-0000-4000-8000-000000000148	d3000002-0000-4000-8000-0000000000ae	Opp 174-2	195000	Closed Won	2024-10-17 11:38:31.49818+00	2024-10-17 11:38:31.49818+00
d3000003-0000-4000-8000-00000000014a	d3000002-0000-4000-8000-0000000000af	Opp 175-2	196000	Closed Lost	2024-10-14 11:38:31.49818+00	2024-10-14 11:38:31.49818+00
d3000003-0000-4000-8000-00000000014c	d3000002-0000-4000-8000-0000000000b0	Opp 176-2	197000	Closed Won	2024-10-11 11:38:31.49818+00	2024-10-11 11:38:31.49818+00
d3000003-0000-4000-8000-00000000014e	d3000002-0000-4000-8000-0000000000b1	Opp 177-2	198000	Closed Won	2024-10-08 11:38:31.49818+00	2024-10-08 11:38:31.49818+00
d3000003-0000-4000-8000-000000000150	d3000002-0000-4000-8000-0000000000b2	Opp 178-2	199000	Closed Lost	2024-10-05 11:38:31.49818+00	2024-10-05 11:38:31.49818+00
d3000003-0000-4000-8000-000000000152	d3000002-0000-4000-8000-0000000000b3	Opp 179-2	200000	Closed Won	2024-10-02 11:38:31.49818+00	2024-10-02 11:38:31.49818+00
d3000003-0000-4000-8000-000000000154	d3000002-0000-4000-8000-0000000000b4	Opp 180-2	201000	Closed Won	2024-09-29 11:38:31.49818+00	2024-09-29 11:38:31.49818+00
d3000003-0000-4000-8000-000000000156	d3000002-0000-4000-8000-0000000000b5	Opp 181-2	202000	Closed Lost	2024-09-26 11:38:31.49818+00	2024-09-26 11:38:31.49818+00
d3000003-0000-4000-8000-000000000158	d3000002-0000-4000-8000-0000000000b6	Opp 182-2	203000	Closed Won	2024-09-23 11:38:31.49818+00	2024-09-23 11:38:31.49818+00
d3000003-0000-4000-8000-00000000015a	d3000002-0000-4000-8000-0000000000b7	Opp 183-2	204000	Closed Won	2024-09-20 11:38:31.49818+00	2024-09-20 11:38:31.49818+00
d3000003-0000-4000-8000-00000000015c	d3000002-0000-4000-8000-0000000000b8	Opp 184-2	205000	Closed Lost	2024-09-17 11:38:31.49818+00	2024-09-17 11:38:31.49818+00
d3000003-0000-4000-8000-00000000015e	d3000002-0000-4000-8000-0000000000b9	Opp 185-2	206000	Closed Won	2024-09-14 11:38:31.49818+00	2024-09-14 11:38:31.49818+00
d3000003-0000-4000-8000-000000000160	d3000002-0000-4000-8000-0000000000ba	Opp 186-2	207000	Closed Won	2024-09-11 11:38:31.49818+00	2024-09-11 11:38:31.49818+00
d3000003-0000-4000-8000-000000000162	d3000002-0000-4000-8000-0000000000bb	Opp 187-2	208000	Closed Lost	2024-09-08 11:38:31.49818+00	2024-09-08 11:38:31.49818+00
d3000003-0000-4000-8000-000000000164	d3000002-0000-4000-8000-0000000000bc	Opp 188-2	209000	Closed Won	2024-09-05 11:38:31.49818+00	2024-09-05 11:38:31.49818+00
d3000003-0000-4000-8000-000000000166	d3000002-0000-4000-8000-0000000000bd	Opp 189-2	210000	Closed Won	2024-09-02 11:38:31.49818+00	2024-09-02 11:38:31.49818+00
d3000003-0000-4000-8000-000000000168	d3000002-0000-4000-8000-0000000000be	Opp 190-2	211000	Closed Lost	2024-08-30 11:38:31.49818+00	2024-08-30 11:38:31.49818+00
d3000003-0000-4000-8000-00000000016a	d3000002-0000-4000-8000-0000000000bf	Opp 191-2	212000	Closed Won	2024-08-27 11:38:31.49818+00	2024-08-27 11:38:31.49818+00
d3000003-0000-4000-8000-00000000016c	d3000002-0000-4000-8000-0000000000c0	Opp 192-2	213000	Closed Won	2024-08-24 11:38:31.49818+00	2024-08-24 11:38:31.49818+00
d3000003-0000-4000-8000-00000000016e	d3000002-0000-4000-8000-0000000000c1	Opp 193-2	214000	Closed Lost	2024-08-21 11:38:31.49818+00	2024-08-21 11:38:31.49818+00
d3000003-0000-4000-8000-000000000170	d3000002-0000-4000-8000-0000000000c2	Opp 194-2	215000	Closed Won	2024-08-18 11:38:31.49818+00	2024-08-18 11:38:31.49818+00
d3000003-0000-4000-8000-000000000172	d3000002-0000-4000-8000-0000000000c3	Opp 195-2	216000	Closed Won	2024-08-15 11:38:31.49818+00	2024-08-15 11:38:31.49818+00
d3000003-0000-4000-8000-000000000174	d3000002-0000-4000-8000-0000000000c4	Opp 196-2	217000	Closed Lost	2024-08-12 11:38:31.49818+00	2024-08-12 11:38:31.49818+00
d3000003-0000-4000-8000-000000000176	d3000002-0000-4000-8000-0000000000c5	Opp 197-2	218000	Closed Won	2024-08-09 11:38:31.49818+00	2024-08-09 11:38:31.49818+00
d3000003-0000-4000-8000-000000000178	d3000002-0000-4000-8000-0000000000c6	Opp 198-2	219000	Closed Won	2024-08-06 11:38:31.49818+00	2024-08-06 11:38:31.49818+00
d3000003-0000-4000-8000-00000000017a	d3000002-0000-4000-8000-0000000000c7	Opp 199-2	220000	Closed Lost	2024-08-03 11:38:31.49818+00	2024-08-03 11:38:31.49818+00
d3000003-0000-4000-8000-00000000017c	d3000002-0000-4000-8000-0000000000c8	Opp 200-2	221000	Closed Won	2024-07-31 11:38:31.49818+00	2024-07-31 11:38:31.49818+00
d3000003-0000-4000-8000-00000000017e	d3000002-0000-4000-8000-0000000000c9	Opp 201-2	222000	Closed Won	2024-07-28 11:38:31.49818+00	2024-07-28 11:38:31.49818+00
d3000003-0000-4000-8000-000000000180	d3000002-0000-4000-8000-0000000000ca	Opp 202-2	223000	Closed Lost	2024-07-25 11:38:31.49818+00	2024-07-25 11:38:31.49818+00
d3000003-0000-4000-8000-000000000182	d3000002-0000-4000-8000-0000000000cb	Opp 203-2	224000	Closed Won	2024-07-22 11:38:31.49818+00	2024-07-22 11:38:31.49818+00
d3000003-0000-4000-8000-000000000184	d3000002-0000-4000-8000-0000000000cc	Opp 204-2	225000	Closed Won	2024-07-19 11:38:31.49818+00	2024-07-19 11:38:31.49818+00
d3000003-0000-4000-8000-000000000186	d3000002-0000-4000-8000-0000000000cd	Opp 205-2	226000	Closed Lost	2024-07-16 11:38:31.49818+00	2024-07-16 11:38:31.49818+00
d3000003-0000-4000-8000-000000000188	d3000002-0000-4000-8000-0000000000ce	Opp 206-2	227000	Closed Won	2024-07-13 11:38:31.49818+00	2024-07-13 11:38:31.49818+00
d3000003-0000-4000-8000-00000000018a	d3000002-0000-4000-8000-0000000000cf	Opp 207-2	228000	Closed Won	2024-07-10 11:38:31.49818+00	2024-07-10 11:38:31.49818+00
d3000003-0000-4000-8000-00000000018c	d3000002-0000-4000-8000-0000000000d0	Opp 208-2	229000	Closed Lost	2024-07-07 11:38:31.49818+00	2024-07-07 11:38:31.49818+00
d3000003-0000-4000-8000-00000000018e	d3000002-0000-4000-8000-0000000000d1	Opp 209-2	30000	Closed Won	2024-07-04 11:38:31.49818+00	2024-07-04 11:38:31.49818+00
d3000003-0000-4000-8000-000000000190	d3000002-0000-4000-8000-0000000000d2	Opp 210-2	31000	Closed Won	2024-07-01 11:38:31.49818+00	2024-07-01 11:38:31.49818+00
\.


--
-- Data for Name: contributor_engagement; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.contributor_engagement (id, person_id, engagement_type, source_system, source_id, occurred_at, metadata, organization_id, entitlement_id, version, created_at, updated_at) FROM stdin;
d200000a-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	volunteer_shift	demo	demo_engagement_1	2026-01-26 11:38:31.591791+00	\N	\N	\N	1	2026-02-25 11:38:31.591791+00	2026-02-25 11:38:31.591791+00
d200000a-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000002	speaker_slot	demo	demo_engagement_2	2026-02-11 11:38:31.591791+00	\N	\N	\N	1	2026-02-25 11:38:31.591791+00	2026-02-25 11:38:31.591791+00
d200000a-0000-4000-8000-000000000003	d1000001-0000-4000-8000-000000000003	authored_content	demo	demo_engagement_3	2026-02-18 11:38:31.591791+00	\N	\N	\N	1	2026-02-25 11:38:31.591791+00	2026-02-25 11:38:31.591791+00
\.


--
-- Data for Name: contributor_profiles; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.contributor_profiles (person_id, contributor_type, effective_from, effective_to, attribution_consent, contact_for_opportunities, terms_version, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d1000001-0000-4000-8000-000000000001	volunteer	\N	\N	t	t	\N	1	2026-02-25 11:38:31.588759+00	2026-02-25 11:38:31.588759+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	speaker	\N	\N	t	f	\N	1	2026-02-25 11:38:31.588759+00	2026-02-25 11:38:31.588759+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	author	\N	\N	f	t	\N	1	2026-02-25 11:38:31.588759+00	2026-02-25 11:38:31.588759+00	\N	\N	\N	\N
\.


--
-- Data for Name: contributor_profiles_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.contributor_profiles_history (history_id, person_id, contributor_type, effective_from, effective_to, attribution_consent, contact_for_opportunities, terms_version, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d1000001-0000-4000-8000-000000000001	volunteer	\N	\N	t	t	\N	1	2026-02-25 11:38:31.588759+00	2026-02-25 11:38:31.588759+00	\N	\N	\N	\N	2026-02-25 11:38:31.588759+00	infinity	\N	\N
2	d1000001-0000-4000-8000-000000000002	speaker	\N	\N	t	f	\N	1	2026-02-25 11:38:31.588759+00	2026-02-25 11:38:31.588759+00	\N	\N	\N	\N	2026-02-25 11:38:31.588759+00	infinity	\N	\N
3	d1000001-0000-4000-8000-000000000003	author	\N	\N	f	t	\N	1	2026-02-25 11:38:31.588759+00	2026-02-25 11:38:31.588759+00	\N	\N	\N	\N	2026-02-25 11:38:31.588759+00	infinity	\N	\N
\.


--
-- Data for Name: contributor_types; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.contributor_types (code, label, description, sort_order) FROM stdin;
volunteer	Volunteer	Event or program volunteers	10
speaker	Speaker	Speakers at events or webinars	20
author	Author	Content authors	30
facilitator	Facilitator	Session or workshop facilitators	40
pro_bono	Pro bono	Other non-paid contributor roles	50
\.


--
-- Data for Name: engagement_types; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.engagement_types (code, label, description, sort_order) FROM stdin;
volunteer_shift	Volunteer shift	Volunteer assignment at an event	10
speaker_slot	Speaker slot	Speaking at a session or event	20
authored_content	Authored content	Authored article, whitepaper, or other content	30
facilitation	Facilitation	Facilitated session or workshop	40
\.


--
-- Data for Name: entitlements; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.entitlements (id, person_id, product_id, status, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, organization_id, source, membership_pool_id, origin_person_id, origin_organization_id) FROM stdin;
d2000007-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000003	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000004	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000005	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000006	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000007	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000008	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
d2000007-0000-4000-8000-000000000009	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000011	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000012	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000013	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000014	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000015	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000016	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000017	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000018	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000019	d1000001-0000-4000-8000-000000000009	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000020	d1000001-0000-4000-8000-00000000000a	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000021	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000022	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000023	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000024	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000025	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000026	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000027	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000028	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000029	d1000001-0000-4000-8000-000000000009	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000030	d1000001-0000-4000-8000-00000000000a	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000031	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000032	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000033	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000034	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000035	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000036	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000037	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000038	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000039	d1000001-0000-4000-8000-000000000009	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000040	d1000001-0000-4000-8000-00000000000a	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000041	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000042	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000043	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000044	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000045	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000046	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
d2000007-0000-4000-8000-000000000047	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	active	1	2026-02-25 11:38:31.457211+00	2026-02-25 11:38:31.457211+00	\N	\N	\N	\N	\N	\N	d2000006-0000-4000-8000-000000000003	\N	\N
\.


--
-- Data for Name: entitlements_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.entitlements_history (history_id, id, person_id, product_id, organization_id, status, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via, membership_pool_id, origin_person_id, origin_organization_id) FROM stdin;
1	d2000007-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
2	d2000007-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
3	d2000007-0000-4000-8000-000000000003	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
4	d2000007-0000-4000-8000-000000000004	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
5	d2000007-0000-4000-8000-000000000005	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
6	d2000007-0000-4000-8000-000000000006	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
7	d2000007-0000-4000-8000-000000000007	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
8	d2000007-0000-4000-8000-000000000008	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000001	\N	\N
9	d2000007-0000-4000-8000-000000000009	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.450062+00	2026-02-25 11:38:31.450062+00	\N	\N	\N	\N	2026-02-25 11:38:31.450062+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
10	d2000007-0000-4000-8000-000000000011	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
11	d2000007-0000-4000-8000-000000000012	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
12	d2000007-0000-4000-8000-000000000013	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
13	d2000007-0000-4000-8000-000000000014	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
14	d2000007-0000-4000-8000-000000000015	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
15	d2000007-0000-4000-8000-000000000016	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
16	d2000007-0000-4000-8000-000000000017	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
17	d2000007-0000-4000-8000-000000000018	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
18	d2000007-0000-4000-8000-000000000019	d1000001-0000-4000-8000-000000000009	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
19	d2000007-0000-4000-8000-000000000020	d1000001-0000-4000-8000-00000000000a	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
20	d2000007-0000-4000-8000-000000000021	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
21	d2000007-0000-4000-8000-000000000022	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
22	d2000007-0000-4000-8000-000000000023	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
23	d2000007-0000-4000-8000-000000000024	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
24	d2000007-0000-4000-8000-000000000025	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
25	d2000007-0000-4000-8000-000000000026	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
26	d2000007-0000-4000-8000-000000000027	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
27	d2000007-0000-4000-8000-000000000028	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
28	d2000007-0000-4000-8000-000000000029	d1000001-0000-4000-8000-000000000009	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
29	d2000007-0000-4000-8000-000000000030	d1000001-0000-4000-8000-00000000000a	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
30	d2000007-0000-4000-8000-000000000031	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
31	d2000007-0000-4000-8000-000000000032	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
32	d2000007-0000-4000-8000-000000000033	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
33	d2000007-0000-4000-8000-000000000034	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
34	d2000007-0000-4000-8000-000000000035	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
35	d2000007-0000-4000-8000-000000000036	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
36	d2000007-0000-4000-8000-000000000037	d1000001-0000-4000-8000-000000000007	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
37	d2000007-0000-4000-8000-000000000038	d1000001-0000-4000-8000-000000000008	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
38	d2000007-0000-4000-8000-000000000039	d1000001-0000-4000-8000-000000000009	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
39	d2000007-0000-4000-8000-000000000040	d1000001-0000-4000-8000-00000000000a	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
40	d2000007-0000-4000-8000-000000000041	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
41	d2000007-0000-4000-8000-000000000042	d1000001-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
42	d2000007-0000-4000-8000-000000000043	d1000001-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
43	d2000007-0000-4000-8000-000000000044	d1000001-0000-4000-8000-000000000004	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
44	d2000007-0000-4000-8000-000000000045	d1000001-0000-4000-8000-000000000005	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
45	d2000007-0000-4000-8000-000000000046	d1000001-0000-4000-8000-000000000006	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.454432+00	2026-02-25 11:38:31.454432+00	\N	\N	\N	\N	2026-02-25 11:38:31.454432+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000002	\N	\N
46	d2000007-0000-4000-8000-000000000047	d1000001-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	\N	active	1	2026-02-25 11:38:31.457211+00	2026-02-25 11:38:31.457211+00	\N	\N	\N	\N	2026-02-25 11:38:31.457211+00	infinity	\N	\N	d2000006-0000-4000-8000-000000000003	\N	\N
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.invoices (id, subscription_id, person_id, organization_id, stripe_invoice_id, stripe_invoice_number, hosted_invoice_url, invoice_pdf_url, status, amount_due_cents, amount_paid_cents, currency, period_start, period_end, due_date, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d2000005-0000-4000-8000-000000000001	d2000004-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	\N	demo_inv_01	\N	\N	\N	paid	2999	2999	usd	2025-12-25 11:38:31.441072+00	2026-01-25 11:38:31.441072+00	\N	1	2025-12-25 11:38:31.441072+00	2026-02-25 11:38:31.441072+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000002	d2000004-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	\N	demo_inv_02	\N	\N	\N	paid	2999	2999	usd	2026-01-25 11:38:31.441072+00	2026-02-25 11:38:31.441072+00	\N	1	2026-01-25 11:38:31.441072+00	2026-02-25 11:38:31.441072+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000003	d2000004-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000002	\N	demo_inv_03	\N	\N	\N	paid	29900	29900	usd	2025-11-25 11:38:31.441072+00	2026-11-25 11:38:31.441072+00	\N	1	2025-11-25 11:38:31.441072+00	2026-02-25 11:38:31.441072+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000004	d2000004-0000-4000-8000-000000000004	d1000001-0000-4000-8000-000000000004	\N	demo_inv_04	\N	\N	\N	paid	2999	2999	usd	2026-01-25 11:38:31.441072+00	2026-02-25 11:38:31.441072+00	\N	1	2026-02-05 11:38:31.441072+00	2026-02-25 11:38:31.441072+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000065	d2000004-0000-4000-8000-000000000065	d1000001-0000-4000-8000-00000000000c	\N	demo_inv_101	\N	\N	\N	paid	2999	2999	usd	2025-12-27 11:38:31.557193+00	2026-01-26 11:38:31.557193+00	\N	1	2025-12-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000066	d2000004-0000-4000-8000-000000000065	d1000001-0000-4000-8000-00000000000c	\N	demo_inv_102	\N	\N	\N	paid	2999	2999	usd	2025-11-27 11:38:31.557193+00	2025-12-27 11:38:31.557193+00	\N	1	2025-11-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000067	d2000004-0000-4000-8000-000000000066	d1000001-0000-4000-8000-00000000000d	\N	demo_inv_103	\N	\N	\N	paid	2999	2999	usd	2025-11-27 11:38:31.557193+00	2025-12-27 11:38:31.557193+00	\N	1	2025-11-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000068	d2000004-0000-4000-8000-000000000066	d1000001-0000-4000-8000-00000000000d	\N	demo_inv_104	\N	\N	\N	paid	2999	2999	usd	2025-10-28 11:38:31.557193+00	2025-11-27 11:38:31.557193+00	\N	1	2025-10-28 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000006b	d2000004-0000-4000-8000-000000000068	d1000001-0000-4000-8000-00000000000f	\N	demo_inv_107	\N	\N	\N	paid	2999	2999	usd	2025-09-28 11:38:31.557193+00	2025-10-28 11:38:31.557193+00	\N	1	2025-09-28 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000006c	d2000004-0000-4000-8000-000000000068	d1000001-0000-4000-8000-00000000000f	\N	demo_inv_108	\N	\N	\N	paid	2999	2999	usd	2025-08-29 11:38:31.557193+00	2025-09-28 11:38:31.557193+00	\N	1	2025-08-29 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000006d	d2000004-0000-4000-8000-000000000069	d1000001-0000-4000-8000-000000000010	\N	demo_inv_109	\N	\N	\N	paid	2999	2999	usd	2025-08-29 11:38:31.557193+00	2025-09-28 11:38:31.557193+00	\N	1	2025-08-29 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000006e	d2000004-0000-4000-8000-000000000069	d1000001-0000-4000-8000-000000000010	\N	demo_inv_110	\N	\N	\N	paid	2999	2999	usd	2025-07-30 11:38:31.557193+00	2025-08-29 11:38:31.557193+00	\N	1	2025-07-30 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000006f	d2000004-0000-4000-8000-00000000006a	d1000001-0000-4000-8000-000000000011	\N	demo_inv_111	\N	\N	\N	paid	2999	2999	usd	2025-07-30 11:38:31.557193+00	2025-08-29 11:38:31.557193+00	\N	1	2025-07-30 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000070	d2000004-0000-4000-8000-00000000006a	d1000001-0000-4000-8000-000000000011	\N	demo_inv_112	\N	\N	\N	paid	2999	2999	usd	2025-06-30 11:38:31.557193+00	2025-07-30 11:38:31.557193+00	\N	1	2025-06-30 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000073	d2000004-0000-4000-8000-00000000006c	d1000001-0000-4000-8000-000000000013	\N	demo_inv_115	\N	\N	\N	paid	2999	2999	usd	2025-05-31 11:38:31.557193+00	2025-06-30 11:38:31.557193+00	\N	1	2025-05-31 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000074	d2000004-0000-4000-8000-00000000006c	d1000001-0000-4000-8000-000000000013	\N	demo_inv_116	\N	\N	\N	paid	2999	2999	usd	2025-05-01 11:38:31.557193+00	2025-05-31 11:38:31.557193+00	\N	1	2025-05-01 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000075	d2000004-0000-4000-8000-00000000006d	d1000001-0000-4000-8000-000000000014	\N	demo_inv_117	\N	\N	\N	paid	2999	2999	usd	2025-05-01 11:38:31.557193+00	2025-05-31 11:38:31.557193+00	\N	1	2025-05-01 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000076	d2000004-0000-4000-8000-00000000006d	d1000001-0000-4000-8000-000000000014	\N	demo_inv_118	\N	\N	\N	paid	2999	2999	usd	2025-04-01 11:38:31.557193+00	2025-05-01 11:38:31.557193+00	\N	1	2025-04-01 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000077	d2000004-0000-4000-8000-00000000006e	d1000001-0000-4000-8000-000000000015	\N	demo_inv_119	\N	\N	\N	paid	2999	2999	usd	2025-04-01 11:38:31.557193+00	2025-05-01 11:38:31.557193+00	\N	1	2025-04-01 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000078	d2000004-0000-4000-8000-00000000006e	d1000001-0000-4000-8000-000000000015	\N	demo_inv_120	\N	\N	\N	paid	2999	2999	usd	2025-03-02 11:38:31.557193+00	2025-04-01 11:38:31.557193+00	\N	1	2025-03-02 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000007b	d2000004-0000-4000-8000-000000000070	d1000001-0000-4000-8000-000000000017	\N	demo_inv_123	\N	\N	\N	paid	2999	2999	usd	2025-01-31 11:38:31.557193+00	2025-03-02 11:38:31.557193+00	\N	1	2025-01-31 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000007c	d2000004-0000-4000-8000-000000000070	d1000001-0000-4000-8000-000000000017	\N	demo_inv_124	\N	\N	\N	paid	2999	2999	usd	2025-01-01 11:38:31.557193+00	2025-01-31 11:38:31.557193+00	\N	1	2025-01-01 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000007d	d2000004-0000-4000-8000-000000000071	d1000001-0000-4000-8000-000000000018	\N	demo_inv_125	\N	\N	\N	paid	2999	2999	usd	2025-01-01 11:38:31.557193+00	2025-01-31 11:38:31.557193+00	\N	1	2025-01-01 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000007e	d2000004-0000-4000-8000-000000000071	d1000001-0000-4000-8000-000000000018	\N	demo_inv_126	\N	\N	\N	paid	2999	2999	usd	2024-12-02 11:38:31.557193+00	2025-01-01 11:38:31.557193+00	\N	1	2024-12-02 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000007f	d2000004-0000-4000-8000-000000000072	d1000001-0000-4000-8000-000000000019	\N	demo_inv_127	\N	\N	\N	paid	2999	2999	usd	2024-12-02 11:38:31.557193+00	2025-01-01 11:38:31.557193+00	\N	1	2024-12-02 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000080	d2000004-0000-4000-8000-000000000072	d1000001-0000-4000-8000-000000000019	\N	demo_inv_128	\N	\N	\N	paid	2999	2999	usd	2024-11-02 11:38:31.557193+00	2024-12-02 11:38:31.557193+00	\N	1	2024-11-02 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000083	d2000004-0000-4000-8000-000000000074	d1000001-0000-4000-8000-00000000001b	\N	demo_inv_131	\N	\N	\N	paid	2999	2999	usd	2024-10-03 11:38:31.557193+00	2024-11-02 11:38:31.557193+00	\N	1	2024-10-03 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000084	d2000004-0000-4000-8000-000000000074	d1000001-0000-4000-8000-00000000001b	\N	demo_inv_132	\N	\N	\N	paid	2999	2999	usd	2024-09-03 11:38:31.557193+00	2024-10-03 11:38:31.557193+00	\N	1	2024-09-03 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000085	d2000004-0000-4000-8000-000000000075	d1000001-0000-4000-8000-00000000001c	\N	demo_inv_133	\N	\N	\N	paid	2999	2999	usd	2024-09-03 11:38:31.557193+00	2024-10-03 11:38:31.557193+00	\N	1	2024-09-03 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000086	d2000004-0000-4000-8000-000000000075	d1000001-0000-4000-8000-00000000001c	\N	demo_inv_134	\N	\N	\N	paid	2999	2999	usd	2024-08-04 11:38:31.557193+00	2024-09-03 11:38:31.557193+00	\N	1	2024-08-04 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000087	d2000004-0000-4000-8000-000000000076	d1000001-0000-4000-8000-00000000001d	\N	demo_inv_135	\N	\N	\N	paid	2999	2999	usd	2024-08-04 11:38:31.557193+00	2024-09-03 11:38:31.557193+00	\N	1	2024-08-04 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000088	d2000004-0000-4000-8000-000000000076	d1000001-0000-4000-8000-00000000001d	\N	demo_inv_136	\N	\N	\N	paid	2999	2999	usd	2024-07-05 11:38:31.557193+00	2024-08-04 11:38:31.557193+00	\N	1	2024-07-05 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000008b	d2000004-0000-4000-8000-000000000078	d1000001-0000-4000-8000-00000000001f	\N	demo_inv_139	\N	\N	\N	paid	2999	2999	usd	2024-06-05 11:38:31.557193+00	2024-07-05 11:38:31.557193+00	\N	1	2024-06-05 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000008c	d2000004-0000-4000-8000-000000000078	d1000001-0000-4000-8000-00000000001f	\N	demo_inv_140	\N	\N	\N	paid	2999	2999	usd	2024-05-06 11:38:31.557193+00	2024-06-05 11:38:31.557193+00	\N	1	2024-05-06 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000008d	d2000004-0000-4000-8000-000000000079	d1000001-0000-4000-8000-000000000020	\N	demo_inv_141	\N	\N	\N	paid	2999	2999	usd	2024-05-06 11:38:31.557193+00	2024-06-05 11:38:31.557193+00	\N	1	2024-05-06 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000008e	d2000004-0000-4000-8000-000000000079	d1000001-0000-4000-8000-000000000020	\N	demo_inv_142	\N	\N	\N	paid	2999	2999	usd	2024-04-06 11:38:31.557193+00	2024-05-06 11:38:31.557193+00	\N	1	2024-04-06 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000008f	d2000004-0000-4000-8000-00000000007a	d1000001-0000-4000-8000-000000000021	\N	demo_inv_143	\N	\N	\N	paid	2999	2999	usd	2024-04-06 11:38:31.557193+00	2024-05-06 11:38:31.557193+00	\N	1	2024-04-06 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000090	d2000004-0000-4000-8000-00000000007a	d1000001-0000-4000-8000-000000000021	\N	demo_inv_144	\N	\N	\N	paid	2999	2999	usd	2024-03-07 11:38:31.557193+00	2024-04-06 11:38:31.557193+00	\N	1	2024-03-07 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000093	d2000004-0000-4000-8000-00000000007c	d1000001-0000-4000-8000-000000000023	\N	demo_inv_147	\N	\N	\N	paid	2999	2999	usd	2024-02-06 11:38:31.557193+00	2024-03-07 11:38:31.557193+00	\N	1	2024-02-06 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000094	d2000004-0000-4000-8000-00000000007c	d1000001-0000-4000-8000-000000000023	\N	demo_inv_148	\N	\N	\N	paid	2999	2999	usd	2024-01-07 11:38:31.557193+00	2024-02-06 11:38:31.557193+00	\N	1	2024-01-07 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000095	d2000004-0000-4000-8000-00000000007d	d1000001-0000-4000-8000-000000000024	\N	demo_inv_149	\N	\N	\N	paid	2999	2999	usd	2024-01-07 11:38:31.557193+00	2024-02-06 11:38:31.557193+00	\N	1	2024-01-07 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000096	d2000004-0000-4000-8000-00000000007d	d1000001-0000-4000-8000-000000000024	\N	demo_inv_150	\N	\N	\N	paid	2999	2999	usd	2023-12-08 11:38:31.557193+00	2024-01-07 11:38:31.557193+00	\N	1	2023-12-08 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000097	d2000004-0000-4000-8000-00000000007e	d1000001-0000-4000-8000-000000000025	\N	demo_inv_151	\N	\N	\N	paid	2999	2999	usd	2023-12-08 11:38:31.557193+00	2024-01-07 11:38:31.557193+00	\N	1	2023-12-08 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000098	d2000004-0000-4000-8000-00000000007e	d1000001-0000-4000-8000-000000000025	\N	demo_inv_152	\N	\N	\N	paid	2999	2999	usd	2023-11-08 11:38:31.557193+00	2023-12-08 11:38:31.557193+00	\N	1	2023-11-08 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000009b	d2000004-0000-4000-8000-000000000080	d1000001-0000-4000-8000-000000000027	\N	demo_inv_155	\N	\N	\N	paid	2999	2999	usd	2023-10-09 11:38:31.557193+00	2023-11-08 11:38:31.557193+00	\N	1	2023-10-09 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000009c	d2000004-0000-4000-8000-000000000080	d1000001-0000-4000-8000-000000000027	\N	demo_inv_156	\N	\N	\N	paid	2999	2999	usd	2023-09-09 11:38:31.557193+00	2023-10-09 11:38:31.557193+00	\N	1	2023-09-09 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000009d	d2000004-0000-4000-8000-000000000081	d1000001-0000-4000-8000-000000000028	\N	demo_inv_157	\N	\N	\N	paid	2999	2999	usd	2023-09-09 11:38:31.557193+00	2023-10-09 11:38:31.557193+00	\N	1	2023-09-09 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000009e	d2000004-0000-4000-8000-000000000081	d1000001-0000-4000-8000-000000000028	\N	demo_inv_158	\N	\N	\N	paid	2999	2999	usd	2023-08-10 11:38:31.557193+00	2023-09-09 11:38:31.557193+00	\N	1	2023-08-10 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-00000000009f	d2000004-0000-4000-8000-000000000082	d1000001-0000-4000-8000-000000000029	\N	demo_inv_159	\N	\N	\N	paid	2999	2999	usd	2023-08-10 11:38:31.557193+00	2023-09-09 11:38:31.557193+00	\N	1	2023-08-10 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000a0	d2000004-0000-4000-8000-000000000082	d1000001-0000-4000-8000-000000000029	\N	demo_inv_160	\N	\N	\N	paid	2999	2999	usd	2023-07-11 11:38:31.557193+00	2023-08-10 11:38:31.557193+00	\N	1	2023-07-11 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000a3	d2000004-0000-4000-8000-000000000084	d1000001-0000-4000-8000-00000000002b	\N	demo_inv_163	\N	\N	\N	paid	2999	2999	usd	2023-06-11 11:38:31.557193+00	2023-07-11 11:38:31.557193+00	\N	1	2023-06-11 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000a4	d2000004-0000-4000-8000-000000000084	d1000001-0000-4000-8000-00000000002b	\N	demo_inv_164	\N	\N	\N	paid	2999	2999	usd	2023-05-12 11:38:31.557193+00	2023-06-11 11:38:31.557193+00	\N	1	2023-05-12 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000a5	d2000004-0000-4000-8000-000000000085	d1000001-0000-4000-8000-00000000002c	\N	demo_inv_165	\N	\N	\N	paid	2999	2999	usd	2023-05-12 11:38:31.557193+00	2023-06-11 11:38:31.557193+00	\N	1	2023-05-12 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000a6	d2000004-0000-4000-8000-000000000085	d1000001-0000-4000-8000-00000000002c	\N	demo_inv_166	\N	\N	\N	paid	2999	2999	usd	2023-04-12 11:38:31.557193+00	2023-05-12 11:38:31.557193+00	\N	1	2023-04-12 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000a7	d2000004-0000-4000-8000-000000000086	d1000001-0000-4000-8000-00000000002d	\N	demo_inv_167	\N	\N	\N	paid	2999	2999	usd	2023-04-12 11:38:31.557193+00	2023-05-12 11:38:31.557193+00	\N	1	2023-04-12 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000a8	d2000004-0000-4000-8000-000000000086	d1000001-0000-4000-8000-00000000002d	\N	demo_inv_168	\N	\N	\N	paid	2999	2999	usd	2023-03-13 11:38:31.557193+00	2023-04-12 11:38:31.557193+00	\N	1	2023-03-13 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ab	d2000004-0000-4000-8000-000000000088	d1000001-0000-4000-8000-00000000002f	\N	demo_inv_171	\N	\N	\N	paid	2999	2999	usd	2023-02-11 11:38:31.557193+00	2023-03-13 11:38:31.557193+00	\N	1	2023-02-11 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ac	d2000004-0000-4000-8000-000000000088	d1000001-0000-4000-8000-00000000002f	\N	demo_inv_172	\N	\N	\N	paid	2999	2999	usd	2023-01-12 11:38:31.557193+00	2023-02-11 11:38:31.557193+00	\N	1	2023-01-12 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ad	d2000004-0000-4000-8000-000000000089	d1000001-0000-4000-8000-000000000030	\N	demo_inv_173	\N	\N	\N	paid	2999	2999	usd	2023-01-12 11:38:31.557193+00	2023-02-11 11:38:31.557193+00	\N	1	2023-01-12 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ae	d2000004-0000-4000-8000-000000000089	d1000001-0000-4000-8000-000000000030	\N	demo_inv_174	\N	\N	\N	paid	2999	2999	usd	2022-12-13 11:38:31.557193+00	2023-01-12 11:38:31.557193+00	\N	1	2022-12-13 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000af	d2000004-0000-4000-8000-00000000008a	d1000001-0000-4000-8000-000000000031	\N	demo_inv_175	\N	\N	\N	paid	2999	2999	usd	2022-12-13 11:38:31.557193+00	2023-01-12 11:38:31.557193+00	\N	1	2022-12-13 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000b0	d2000004-0000-4000-8000-00000000008a	d1000001-0000-4000-8000-000000000031	\N	demo_inv_176	\N	\N	\N	paid	2999	2999	usd	2022-11-13 11:38:31.557193+00	2022-12-13 11:38:31.557193+00	\N	1	2022-11-13 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000b3	d2000004-0000-4000-8000-00000000008c	d1000001-0000-4000-8000-000000000033	\N	demo_inv_179	\N	\N	\N	paid	2999	2999	usd	2022-10-14 11:38:31.557193+00	2022-11-13 11:38:31.557193+00	\N	1	2022-10-14 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000b4	d2000004-0000-4000-8000-00000000008c	d1000001-0000-4000-8000-000000000033	\N	demo_inv_180	\N	\N	\N	paid	2999	2999	usd	2022-09-14 11:38:31.557193+00	2022-10-14 11:38:31.557193+00	\N	1	2022-09-14 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000b5	d2000004-0000-4000-8000-00000000008d	d1000001-0000-4000-8000-000000000034	\N	demo_inv_181	\N	\N	\N	paid	2999	2999	usd	2022-09-14 11:38:31.557193+00	2022-10-14 11:38:31.557193+00	\N	1	2022-09-14 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000b6	d2000004-0000-4000-8000-00000000008d	d1000001-0000-4000-8000-000000000034	\N	demo_inv_182	\N	\N	\N	paid	2999	2999	usd	2022-08-15 11:38:31.557193+00	2022-09-14 11:38:31.557193+00	\N	1	2022-08-15 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000b7	d2000004-0000-4000-8000-00000000008e	d1000001-0000-4000-8000-000000000035	\N	demo_inv_183	\N	\N	\N	paid	2999	2999	usd	2022-08-15 11:38:31.557193+00	2022-09-14 11:38:31.557193+00	\N	1	2022-08-15 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000b8	d2000004-0000-4000-8000-00000000008e	d1000001-0000-4000-8000-000000000035	\N	demo_inv_184	\N	\N	\N	paid	2999	2999	usd	2022-07-16 11:38:31.557193+00	2022-08-15 11:38:31.557193+00	\N	1	2022-07-16 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000bb	d2000004-0000-4000-8000-000000000090	d1000001-0000-4000-8000-000000000037	\N	demo_inv_187	\N	\N	\N	paid	2999	2999	usd	2022-06-16 11:38:31.557193+00	2022-07-16 11:38:31.557193+00	\N	1	2022-06-16 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000bc	d2000004-0000-4000-8000-000000000090	d1000001-0000-4000-8000-000000000037	\N	demo_inv_188	\N	\N	\N	paid	2999	2999	usd	2022-05-17 11:38:31.557193+00	2022-06-16 11:38:31.557193+00	\N	1	2022-05-17 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000bd	d2000004-0000-4000-8000-000000000091	d1000001-0000-4000-8000-000000000038	\N	demo_inv_189	\N	\N	\N	paid	2999	2999	usd	2022-05-17 11:38:31.557193+00	2022-06-16 11:38:31.557193+00	\N	1	2022-05-17 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000be	d2000004-0000-4000-8000-000000000091	d1000001-0000-4000-8000-000000000038	\N	demo_inv_190	\N	\N	\N	paid	2999	2999	usd	2022-04-17 11:38:31.557193+00	2022-05-17 11:38:31.557193+00	\N	1	2022-04-17 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000bf	d2000004-0000-4000-8000-000000000092	d1000001-0000-4000-8000-000000000039	\N	demo_inv_191	\N	\N	\N	paid	2999	2999	usd	2022-04-17 11:38:31.557193+00	2022-05-17 11:38:31.557193+00	\N	1	2022-04-17 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000c0	d2000004-0000-4000-8000-000000000092	d1000001-0000-4000-8000-000000000039	\N	demo_inv_192	\N	\N	\N	paid	2999	2999	usd	2022-03-18 11:38:31.557193+00	2022-04-17 11:38:31.557193+00	\N	1	2022-03-18 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000c3	d2000004-0000-4000-8000-000000000094	d1000001-0000-4000-8000-00000000003b	\N	demo_inv_195	\N	\N	\N	paid	2999	2999	usd	2022-02-16 11:38:31.557193+00	2022-03-18 11:38:31.557193+00	\N	1	2022-02-16 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000c4	d2000004-0000-4000-8000-000000000094	d1000001-0000-4000-8000-00000000003b	\N	demo_inv_196	\N	\N	\N	paid	2999	2999	usd	2022-01-17 11:38:31.557193+00	2022-02-16 11:38:31.557193+00	\N	1	2022-01-17 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000c5	d2000004-0000-4000-8000-000000000095	d1000001-0000-4000-8000-00000000003c	\N	demo_inv_197	\N	\N	\N	paid	2999	2999	usd	2022-01-17 11:38:31.557193+00	2022-02-16 11:38:31.557193+00	\N	1	2022-01-17 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000c6	d2000004-0000-4000-8000-000000000095	d1000001-0000-4000-8000-00000000003c	\N	demo_inv_198	\N	\N	\N	paid	2999	2999	usd	2021-12-18 11:38:31.557193+00	2022-01-17 11:38:31.557193+00	\N	1	2021-12-18 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000c7	d2000004-0000-4000-8000-000000000096	d1000001-0000-4000-8000-00000000003d	\N	demo_inv_199	\N	\N	\N	paid	2999	2999	usd	2021-12-18 11:38:31.557193+00	2022-01-17 11:38:31.557193+00	\N	1	2021-12-18 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000c8	d2000004-0000-4000-8000-000000000096	d1000001-0000-4000-8000-00000000003d	\N	demo_inv_200	\N	\N	\N	paid	2999	2999	usd	2021-11-18 11:38:31.557193+00	2021-12-18 11:38:31.557193+00	\N	1	2021-11-18 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000cb	d2000004-0000-4000-8000-000000000098	d1000001-0000-4000-8000-00000000003f	\N	demo_inv_203	\N	\N	\N	paid	2999	2999	usd	2021-10-19 11:38:31.557193+00	2021-11-18 11:38:31.557193+00	\N	1	2021-10-19 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000cc	d2000004-0000-4000-8000-000000000098	d1000001-0000-4000-8000-00000000003f	\N	demo_inv_204	\N	\N	\N	paid	2999	2999	usd	2021-09-19 11:38:31.557193+00	2021-10-19 11:38:31.557193+00	\N	1	2021-09-19 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000cd	d2000004-0000-4000-8000-000000000099	d1000001-0000-4000-8000-000000000040	\N	demo_inv_205	\N	\N	\N	paid	2999	2999	usd	2021-09-19 11:38:31.557193+00	2021-10-19 11:38:31.557193+00	\N	1	2021-09-19 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ce	d2000004-0000-4000-8000-000000000099	d1000001-0000-4000-8000-000000000040	\N	demo_inv_206	\N	\N	\N	paid	2999	2999	usd	2021-08-20 11:38:31.557193+00	2021-09-19 11:38:31.557193+00	\N	1	2021-08-20 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000cf	d2000004-0000-4000-8000-00000000009a	d1000001-0000-4000-8000-000000000041	\N	demo_inv_207	\N	\N	\N	paid	2999	2999	usd	2021-08-20 11:38:31.557193+00	2021-09-19 11:38:31.557193+00	\N	1	2021-08-20 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000d0	d2000004-0000-4000-8000-00000000009a	d1000001-0000-4000-8000-000000000041	\N	demo_inv_208	\N	\N	\N	paid	2999	2999	usd	2021-07-21 11:38:31.557193+00	2021-08-20 11:38:31.557193+00	\N	1	2021-07-21 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000d3	d2000004-0000-4000-8000-00000000009c	d1000001-0000-4000-8000-000000000043	\N	demo_inv_211	\N	\N	\N	paid	2999	2999	usd	2021-06-21 11:38:31.557193+00	2021-07-21 11:38:31.557193+00	\N	1	2021-06-21 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000d4	d2000004-0000-4000-8000-00000000009c	d1000001-0000-4000-8000-000000000043	\N	demo_inv_212	\N	\N	\N	paid	2999	2999	usd	2021-05-22 11:38:31.557193+00	2021-06-21 11:38:31.557193+00	\N	1	2021-05-22 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000d5	d2000004-0000-4000-8000-00000000009d	d1000001-0000-4000-8000-000000000044	\N	demo_inv_213	\N	\N	\N	paid	2999	2999	usd	2021-05-22 11:38:31.557193+00	2021-06-21 11:38:31.557193+00	\N	1	2021-05-22 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000d6	d2000004-0000-4000-8000-00000000009d	d1000001-0000-4000-8000-000000000044	\N	demo_inv_214	\N	\N	\N	paid	2999	2999	usd	2021-04-22 11:38:31.557193+00	2021-05-22 11:38:31.557193+00	\N	1	2021-04-22 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000d7	d2000004-0000-4000-8000-00000000009e	d1000001-0000-4000-8000-000000000045	\N	demo_inv_215	\N	\N	\N	paid	2999	2999	usd	2021-04-22 11:38:31.557193+00	2021-05-22 11:38:31.557193+00	\N	1	2021-04-22 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000d8	d2000004-0000-4000-8000-00000000009e	d1000001-0000-4000-8000-000000000045	\N	demo_inv_216	\N	\N	\N	paid	2999	2999	usd	2021-03-23 11:38:31.557193+00	2021-04-22 11:38:31.557193+00	\N	1	2021-03-23 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000db	d2000004-0000-4000-8000-0000000000a0	d1000001-0000-4000-8000-000000000047	\N	demo_inv_219	\N	\N	\N	paid	2999	2999	usd	2021-02-21 11:38:31.557193+00	2021-03-23 11:38:31.557193+00	\N	1	2021-02-21 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000dc	d2000004-0000-4000-8000-0000000000a0	d1000001-0000-4000-8000-000000000047	\N	demo_inv_220	\N	\N	\N	paid	2999	2999	usd	2021-01-22 11:38:31.557193+00	2021-02-21 11:38:31.557193+00	\N	1	2021-01-22 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000dd	d2000004-0000-4000-8000-0000000000a1	d1000001-0000-4000-8000-000000000048	\N	demo_inv_221	\N	\N	\N	paid	2999	2999	usd	2021-01-22 11:38:31.557193+00	2021-02-21 11:38:31.557193+00	\N	1	2021-01-22 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000de	d2000004-0000-4000-8000-0000000000a1	d1000001-0000-4000-8000-000000000048	\N	demo_inv_222	\N	\N	\N	paid	2999	2999	usd	2020-12-23 11:38:31.557193+00	2021-01-22 11:38:31.557193+00	\N	1	2020-12-23 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000df	d2000004-0000-4000-8000-0000000000a2	d1000001-0000-4000-8000-000000000049	\N	demo_inv_223	\N	\N	\N	paid	2999	2999	usd	2020-12-23 11:38:31.557193+00	2021-01-22 11:38:31.557193+00	\N	1	2020-12-23 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000e0	d2000004-0000-4000-8000-0000000000a2	d1000001-0000-4000-8000-000000000049	\N	demo_inv_224	\N	\N	\N	paid	2999	2999	usd	2020-11-23 11:38:31.557193+00	2020-12-23 11:38:31.557193+00	\N	1	2020-11-23 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000e3	d2000004-0000-4000-8000-0000000000a4	d1000001-0000-4000-8000-00000000004b	\N	demo_inv_227	\N	\N	\N	paid	2999	2999	usd	2020-10-24 11:38:31.557193+00	2020-11-23 11:38:31.557193+00	\N	1	2020-10-24 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000e4	d2000004-0000-4000-8000-0000000000a4	d1000001-0000-4000-8000-00000000004b	\N	demo_inv_228	\N	\N	\N	paid	2999	2999	usd	2020-09-24 11:38:31.557193+00	2020-10-24 11:38:31.557193+00	\N	1	2020-09-24 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000e5	d2000004-0000-4000-8000-0000000000a5	d1000001-0000-4000-8000-00000000004c	\N	demo_inv_229	\N	\N	\N	paid	2999	2999	usd	2020-09-24 11:38:31.557193+00	2020-10-24 11:38:31.557193+00	\N	1	2020-09-24 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000e6	d2000004-0000-4000-8000-0000000000a5	d1000001-0000-4000-8000-00000000004c	\N	demo_inv_230	\N	\N	\N	paid	2999	2999	usd	2020-08-25 11:38:31.557193+00	2020-09-24 11:38:31.557193+00	\N	1	2020-08-25 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000e7	d2000004-0000-4000-8000-0000000000a6	d1000001-0000-4000-8000-00000000004d	\N	demo_inv_231	\N	\N	\N	paid	2999	2999	usd	2020-08-25 11:38:31.557193+00	2020-09-24 11:38:31.557193+00	\N	1	2020-08-25 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000e8	d2000004-0000-4000-8000-0000000000a6	d1000001-0000-4000-8000-00000000004d	\N	demo_inv_232	\N	\N	\N	paid	2999	2999	usd	2020-07-26 11:38:31.557193+00	2020-08-25 11:38:31.557193+00	\N	1	2020-07-26 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000eb	d2000004-0000-4000-8000-0000000000a8	d1000001-0000-4000-8000-00000000004f	\N	demo_inv_235	\N	\N	\N	paid	2999	2999	usd	2020-06-26 11:38:31.557193+00	2020-07-26 11:38:31.557193+00	\N	1	2020-06-26 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ec	d2000004-0000-4000-8000-0000000000a8	d1000001-0000-4000-8000-00000000004f	\N	demo_inv_236	\N	\N	\N	paid	2999	2999	usd	2020-05-27 11:38:31.557193+00	2020-06-26 11:38:31.557193+00	\N	1	2020-05-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ed	d2000004-0000-4000-8000-0000000000a9	d1000001-0000-4000-8000-000000000050	\N	demo_inv_237	\N	\N	\N	paid	2999	2999	usd	2020-05-27 11:38:31.557193+00	2020-06-26 11:38:31.557193+00	\N	1	2020-05-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ee	d2000004-0000-4000-8000-0000000000a9	d1000001-0000-4000-8000-000000000050	\N	demo_inv_238	\N	\N	\N	paid	2999	2999	usd	2020-04-27 11:38:31.557193+00	2020-05-27 11:38:31.557193+00	\N	1	2020-04-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ef	d2000004-0000-4000-8000-0000000000aa	d1000001-0000-4000-8000-000000000051	\N	demo_inv_239	\N	\N	\N	paid	2999	2999	usd	2020-04-27 11:38:31.557193+00	2020-05-27 11:38:31.557193+00	\N	1	2020-04-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000f0	d2000004-0000-4000-8000-0000000000aa	d1000001-0000-4000-8000-000000000051	\N	demo_inv_240	\N	\N	\N	paid	2999	2999	usd	2020-03-28 11:38:31.557193+00	2020-04-27 11:38:31.557193+00	\N	1	2020-03-28 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000f3	d2000004-0000-4000-8000-0000000000ac	d1000001-0000-4000-8000-000000000053	\N	demo_inv_243	\N	\N	\N	paid	2999	2999	usd	2020-02-27 11:38:31.557193+00	2020-03-28 11:38:31.557193+00	\N	1	2020-02-27 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000f4	d2000004-0000-4000-8000-0000000000ac	d1000001-0000-4000-8000-000000000053	\N	demo_inv_244	\N	\N	\N	paid	2999	2999	usd	2020-01-28 11:38:31.557193+00	2020-02-27 11:38:31.557193+00	\N	1	2020-01-28 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000f5	d2000004-0000-4000-8000-0000000000ad	d1000001-0000-4000-8000-000000000054	\N	demo_inv_245	\N	\N	\N	paid	2999	2999	usd	2020-01-28 11:38:31.557193+00	2020-02-27 11:38:31.557193+00	\N	1	2020-01-28 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000f6	d2000004-0000-4000-8000-0000000000ad	d1000001-0000-4000-8000-000000000054	\N	demo_inv_246	\N	\N	\N	paid	2999	2999	usd	2019-12-29 11:38:31.557193+00	2020-01-28 11:38:31.557193+00	\N	1	2019-12-29 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000f7	d2000004-0000-4000-8000-0000000000ae	d1000001-0000-4000-8000-000000000055	\N	demo_inv_247	\N	\N	\N	paid	2999	2999	usd	2019-12-29 11:38:31.557193+00	2020-01-28 11:38:31.557193+00	\N	1	2019-12-29 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000f8	d2000004-0000-4000-8000-0000000000ae	d1000001-0000-4000-8000-000000000055	\N	demo_inv_248	\N	\N	\N	paid	2999	2999	usd	2019-11-29 11:38:31.557193+00	2019-12-29 11:38:31.557193+00	\N	1	2019-11-29 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000fb	d2000004-0000-4000-8000-0000000000b0	d1000001-0000-4000-8000-000000000057	\N	demo_inv_251	\N	\N	\N	paid	2999	2999	usd	2019-10-30 11:38:31.557193+00	2019-11-29 11:38:31.557193+00	\N	1	2019-10-30 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000fc	d2000004-0000-4000-8000-0000000000b0	d1000001-0000-4000-8000-000000000057	\N	demo_inv_252	\N	\N	\N	paid	2999	2999	usd	2019-09-30 11:38:31.557193+00	2019-10-30 11:38:31.557193+00	\N	1	2019-09-30 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000fd	d2000004-0000-4000-8000-0000000000b1	d1000001-0000-4000-8000-000000000058	\N	demo_inv_253	\N	\N	\N	paid	2999	2999	usd	2019-09-30 11:38:31.557193+00	2019-10-30 11:38:31.557193+00	\N	1	2019-09-30 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000fe	d2000004-0000-4000-8000-0000000000b1	d1000001-0000-4000-8000-000000000058	\N	demo_inv_254	\N	\N	\N	paid	2999	2999	usd	2019-08-31 11:38:31.557193+00	2019-09-30 11:38:31.557193+00	\N	1	2019-08-31 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-0000000000ff	d2000004-0000-4000-8000-0000000000b2	d1000001-0000-4000-8000-000000000059	\N	demo_inv_255	\N	\N	\N	paid	2999	2999	usd	2019-08-31 11:38:31.557193+00	2019-09-30 11:38:31.557193+00	\N	1	2019-08-31 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000100	d2000004-0000-4000-8000-0000000000b2	d1000001-0000-4000-8000-000000000059	\N	demo_inv_256	\N	\N	\N	paid	2999	2999	usd	2019-08-01 11:38:31.557193+00	2019-08-31 11:38:31.557193+00	\N	1	2019-08-01 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000103	d2000004-0000-4000-8000-0000000000b4	d1000001-0000-4000-8000-00000000005b	\N	demo_inv_259	\N	\N	\N	paid	2999	2999	usd	2019-07-02 11:38:31.557193+00	2019-08-01 11:38:31.557193+00	\N	1	2019-07-02 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
d2000005-0000-4000-8000-000000000104	d2000004-0000-4000-8000-0000000000b4	d1000001-0000-4000-8000-00000000005b	\N	demo_inv_260	\N	\N	\N	paid	2999	2999	usd	2019-06-02 11:38:31.557193+00	2019-07-02 11:38:31.557193+00	\N	1	2019-06-02 11:38:31.557193+00	2026-02-25 11:38:31.557193+00	\N	\N	\N	\N
\.


--
-- Data for Name: membership_plans; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.membership_plans (id, product_id, code, name, billing_interval, price_cents, currency, stripe_price_id, status, is_organization_level, trial_days, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d2000002-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000001	demo_pro_monthly	Demo Pro Monthly	month	2999	usd	\N	active	f	\N	1	2026-02-25 11:38:31.430217+00	2026-02-25 11:38:31.430217+00	\N	\N	\N	\N
d2000002-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000001	demo_pro_annual	Demo Pro Annual	year	29900	usd	\N	active	f	\N	1	2026-02-25 11:38:31.430217+00	2026-02-25 11:38:31.430217+00	\N	\N	\N	\N
\.


--
-- Data for Name: memberships; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.memberships (id, person_id, status, expires_at, version, created_at, updated_at, name, created_by_id, created_via, updated_by_id, updated_via, organization_id) FROM stdin;
d2000008-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000002	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000003	d1000001-0000-4000-8000-000000000003	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000004	d1000001-0000-4000-8000-000000000004	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000005	d1000001-0000-4000-8000-000000000005	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000006	d1000001-0000-4000-8000-000000000006	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000007	d1000001-0000-4000-8000-000000000007	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000008	d1000001-0000-4000-8000-000000000008	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-000000000009	d1000001-0000-4000-8000-000000000009	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
d2000008-0000-4000-8000-00000000000a	d1000001-0000-4000-8000-00000000000a	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: memberships_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.memberships_history (history_id, id, person_id, organization_id, name, status, expires_at, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d2000008-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
2	d2000008-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000002	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
3	d2000008-0000-4000-8000-000000000003	d1000001-0000-4000-8000-000000000003	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
4	d2000008-0000-4000-8000-000000000004	d1000001-0000-4000-8000-000000000004	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
5	d2000008-0000-4000-8000-000000000005	d1000001-0000-4000-8000-000000000005	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
6	d2000008-0000-4000-8000-000000000006	d1000001-0000-4000-8000-000000000006	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
7	d2000008-0000-4000-8000-000000000007	d1000001-0000-4000-8000-000000000007	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
8	d2000008-0000-4000-8000-000000000008	d1000001-0000-4000-8000-000000000008	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
9	d2000008-0000-4000-8000-000000000009	d1000001-0000-4000-8000-000000000009	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
10	d2000008-0000-4000-8000-00000000000a	d1000001-0000-4000-8000-00000000000a	\N	\N	active	2027-02-25 11:38:31.573369+00	1	2026-02-25 11:38:31.573369+00	2026-02-25 11:38:31.573369+00	\N	\N	\N	\N	2026-02-25 11:38:31.573369+00	infinity	\N	\N
\.


--
-- Data for Name: organization_invites; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.organization_invites (id, token, organization_id, invited_by_person_id, email, role, expires_at, status, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d2000009-0000-4000-8000-000000000001	demo_invite_token_alpha	d2000003-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	invitee1@example.com	member	2026-03-04 11:38:31.586452+00	pending	1	2026-02-25 11:38:31.586452+00	2026-02-25 11:38:31.586452+00	\N	\N	\N	\N
d2000009-0000-4000-8000-000000000002	demo_invite_token_beta	d2000003-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000004	invitee2@example.com	member	2026-03-04 11:38:31.586452+00	pending	1	2026-02-25 11:38:31.586452+00	2026-02-25 11:38:31.586452+00	\N	\N	\N	\N
\.


--
-- Data for Name: organization_membership_pools; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.organization_membership_pools (id, organization_id, product_id, total_seats, status, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d2000006-0000-4000-8000-000000000001	d2000003-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	10	active	\N	\N	1	2026-02-25 11:38:31.445886+00	2026-02-25 11:38:31.445886+00	\N	\N	\N	\N
d2000006-0000-4000-8000-000000000002	d2000003-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	50	active	\N	\N	1	2026-02-25 11:38:31.445886+00	2026-02-25 11:38:31.445886+00	\N	\N	\N	\N
d2000006-0000-4000-8000-000000000003	d2000003-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	5	active	\N	\N	1	2026-02-25 11:38:31.445886+00	2026-02-25 11:38:31.445886+00	\N	\N	\N	\N
\.


--
-- Data for Name: organization_membership_pools_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.organization_membership_pools_history (history_id, id, organization_id, product_id, total_seats, status, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d2000006-0000-4000-8000-000000000001	d2000003-0000-4000-8000-000000000001	d2000001-0000-4000-8000-000000000002	10	active	\N	\N	1	2026-02-25 11:38:31.445886+00	2026-02-25 11:38:31.445886+00	\N	\N	\N	\N	2026-02-25 11:38:31.445886+00	infinity	\N	\N
2	d2000006-0000-4000-8000-000000000002	d2000003-0000-4000-8000-000000000002	d2000001-0000-4000-8000-000000000002	50	active	\N	\N	1	2026-02-25 11:38:31.445886+00	2026-02-25 11:38:31.445886+00	\N	\N	\N	\N	2026-02-25 11:38:31.445886+00	infinity	\N	\N
3	d2000006-0000-4000-8000-000000000003	d2000003-0000-4000-8000-000000000003	d2000001-0000-4000-8000-000000000002	5	active	\N	\N	1	2026-02-25 11:38:31.445886+00	2026-02-25 11:38:31.445886+00	\N	\N	\N	\N	2026-02-25 11:38:31.445886+00	infinity	\N	\N
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.organizations (id, name, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, category, stripe_customer_id) FROM stdin;
d2000003-0000-4000-8000-000000000001	Demo Corp Alpha	1	2026-02-25 11:38:31.432385+00	2026-02-25 11:38:31.432385+00	\N	\N	\N	\N	seed	\N
d2000003-0000-4000-8000-000000000002	Demo Corp Beta	1	2026-02-25 11:38:31.432385+00	2026-02-25 11:38:31.432385+00	\N	\N	\N	\N	fortune500	\N
d2000003-0000-4000-8000-000000000003	Demo College	1	2026-02-25 11:38:31.432385+00	2026-02-25 11:38:31.432385+00	\N	\N	\N	\N	college	\N
\.


--
-- Data for Name: organizations_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.organizations_history (history_id, id, name, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via, category) FROM stdin;
1	d2000003-0000-4000-8000-000000000001	Demo Corp Alpha	1	2026-02-25 11:38:31.432385+00	2026-02-25 11:38:31.432385+00	\N	\N	\N	\N	2026-02-25 11:38:31.432385+00	infinity	\N	\N	seed
2	d2000003-0000-4000-8000-000000000002	Demo Corp Beta	1	2026-02-25 11:38:31.432385+00	2026-02-25 11:38:31.432385+00	\N	\N	\N	\N	2026-02-25 11:38:31.432385+00	infinity	\N	\N	fortune500
3	d2000003-0000-4000-8000-000000000003	Demo College	1	2026-02-25 11:38:31.432385+00	2026-02-25 11:38:31.432385+00	\N	\N	\N	\N	2026-02-25 11:38:31.432385+00	infinity	\N	\N	college
\.


--
-- Data for Name: person_entitlements; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.person_entitlements (person_id, entitlement_id, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000001	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000002	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000003	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000004	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000005	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000006	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000007	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000008	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000009	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000011	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000012	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000013	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000014	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000015	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000016	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000017	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000018	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000009	d2000007-0000-4000-8000-000000000019	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000a	d2000007-0000-4000-8000-000000000020	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000021	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000022	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000023	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000024	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000025	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000026	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000027	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000028	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000009	d2000007-0000-4000-8000-000000000029	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000a	d2000007-0000-4000-8000-000000000030	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000031	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000032	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000033	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000034	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000035	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000036	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000037	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000038	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000009	d2000007-0000-4000-8000-000000000039	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000a	d2000007-0000-4000-8000-000000000040	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000041	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000042	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000043	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000044	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000045	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000046	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000047	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N
\.


--
-- Data for Name: person_entitlements_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.person_entitlements_history (history_id, person_id, entitlement_id, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000001	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
2	d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000002	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
3	d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000003	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
4	d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000004	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
5	d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000005	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
6	d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000006	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
7	d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000007	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
8	d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000008	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
9	d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000009	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
10	d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000011	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
11	d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000012	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
12	d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000013	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
13	d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000014	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
14	d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000015	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
15	d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000016	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
16	d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000017	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
17	d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000018	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
18	d1000001-0000-4000-8000-000000000009	d2000007-0000-4000-8000-000000000019	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
19	d1000001-0000-4000-8000-00000000000a	d2000007-0000-4000-8000-000000000020	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
20	d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000021	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
21	d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000022	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
22	d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000023	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
23	d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000024	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
24	d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000025	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
25	d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000026	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
26	d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000027	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
27	d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000028	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
28	d1000001-0000-4000-8000-000000000009	d2000007-0000-4000-8000-000000000029	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
29	d1000001-0000-4000-8000-00000000000a	d2000007-0000-4000-8000-000000000030	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
30	d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000031	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
31	d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000032	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
32	d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000033	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
33	d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000034	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
34	d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000035	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
35	d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000036	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
36	d1000001-0000-4000-8000-000000000007	d2000007-0000-4000-8000-000000000037	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
37	d1000001-0000-4000-8000-000000000008	d2000007-0000-4000-8000-000000000038	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
38	d1000001-0000-4000-8000-000000000009	d2000007-0000-4000-8000-000000000039	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
39	d1000001-0000-4000-8000-00000000000a	d2000007-0000-4000-8000-000000000040	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
40	d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000041	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
41	d1000001-0000-4000-8000-000000000002	d2000007-0000-4000-8000-000000000042	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
42	d1000001-0000-4000-8000-000000000003	d2000007-0000-4000-8000-000000000043	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
43	d1000001-0000-4000-8000-000000000004	d2000007-0000-4000-8000-000000000044	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
44	d1000001-0000-4000-8000-000000000005	d2000007-0000-4000-8000-000000000045	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
45	d1000001-0000-4000-8000-000000000006	d2000007-0000-4000-8000-000000000046	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
46	d1000001-0000-4000-8000-000000000001	d2000007-0000-4000-8000-000000000047	\N	\N	1	2026-02-25 11:38:31.581821+00	2026-02-25 11:38:31.581821+00	\N	\N	\N	\N	2026-02-25 11:38:31.581821+00	infinity	\N	\N
\.


--
-- Data for Name: person_memberships; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.person_memberships (person_id, membership_id, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d1000001-0000-4000-8000-000000000001	d2000008-0000-4000-8000-000000000001	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	d2000008-0000-4000-8000-000000000002	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	d2000008-0000-4000-8000-000000000003	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	d2000008-0000-4000-8000-000000000004	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	d2000008-0000-4000-8000-000000000005	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	d2000008-0000-4000-8000-000000000006	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000007	d2000008-0000-4000-8000-000000000007	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000008	d2000008-0000-4000-8000-000000000008	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000009	d2000008-0000-4000-8000-000000000009	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000a	d2000008-0000-4000-8000-00000000000a	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N
\.


--
-- Data for Name: person_memberships_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.person_memberships_history (history_id, person_id, membership_id, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d1000001-0000-4000-8000-000000000001	d2000008-0000-4000-8000-000000000001	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
2	d1000001-0000-4000-8000-000000000002	d2000008-0000-4000-8000-000000000002	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
3	d1000001-0000-4000-8000-000000000003	d2000008-0000-4000-8000-000000000003	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
4	d1000001-0000-4000-8000-000000000004	d2000008-0000-4000-8000-000000000004	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
5	d1000001-0000-4000-8000-000000000005	d2000008-0000-4000-8000-000000000005	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
6	d1000001-0000-4000-8000-000000000006	d2000008-0000-4000-8000-000000000006	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
7	d1000001-0000-4000-8000-000000000007	d2000008-0000-4000-8000-000000000007	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
8	d1000001-0000-4000-8000-000000000008	d2000008-0000-4000-8000-000000000008	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
9	d1000001-0000-4000-8000-000000000009	d2000008-0000-4000-8000-000000000009	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
10	d1000001-0000-4000-8000-00000000000a	d2000008-0000-4000-8000-00000000000a	\N	\N	1	2026-02-25 11:38:31.576719+00	2026-02-25 11:38:31.576719+00	\N	\N	\N	\N	2026-02-25 11:38:31.576719+00	infinity	\N	\N
\.


--
-- Data for Name: person_organizations; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.person_organizations (person_id, organization_id, role, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d1000001-0000-4000-8000-000000000001	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000b	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000c	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000d	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000e	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000f	d2000003-0000-4000-8000-000000000003	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000010	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000011	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000012	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000013	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000014	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000015	d2000003-0000-4000-8000-000000000003	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000016	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000017	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000018	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000019	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001a	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001b	d2000003-0000-4000-8000-000000000003	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001c	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001d	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001e	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N
\.


--
-- Data for Name: person_organizations_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.person_organizations_history (history_id, person_id, organization_id, role, effective_from, effective_to, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d1000001-0000-4000-8000-000000000001	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N	2026-02-25 11:38:31.567701+00	infinity	\N	\N
2	d1000001-0000-4000-8000-000000000002	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N	2026-02-25 11:38:31.567701+00	infinity	\N	\N
3	d1000001-0000-4000-8000-000000000003	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N	2026-02-25 11:38:31.567701+00	infinity	\N	\N
4	d1000001-0000-4000-8000-000000000004	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N	2026-02-25 11:38:31.567701+00	infinity	\N	\N
5	d1000001-0000-4000-8000-000000000005	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N	2026-02-25 11:38:31.567701+00	infinity	\N	\N
6	d1000001-0000-4000-8000-000000000006	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.567701+00	2026-02-25 11:38:31.567701+00	\N	\N	\N	\N	2026-02-25 11:38:31.567701+00	infinity	\N	\N
7	d1000001-0000-4000-8000-00000000000b	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
8	d1000001-0000-4000-8000-00000000000c	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
9	d1000001-0000-4000-8000-00000000000d	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
10	d1000001-0000-4000-8000-00000000000e	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
11	d1000001-0000-4000-8000-00000000000f	d2000003-0000-4000-8000-000000000003	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
12	d1000001-0000-4000-8000-000000000010	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
13	d1000001-0000-4000-8000-000000000011	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
14	d1000001-0000-4000-8000-000000000012	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
15	d1000001-0000-4000-8000-000000000013	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
16	d1000001-0000-4000-8000-000000000014	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
17	d1000001-0000-4000-8000-000000000015	d2000003-0000-4000-8000-000000000003	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
18	d1000001-0000-4000-8000-000000000016	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
19	d1000001-0000-4000-8000-000000000017	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
20	d1000001-0000-4000-8000-000000000018	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
21	d1000001-0000-4000-8000-000000000019	d2000003-0000-4000-8000-000000000001	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
22	d1000001-0000-4000-8000-00000000001a	d2000003-0000-4000-8000-000000000002	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
23	d1000001-0000-4000-8000-00000000001b	d2000003-0000-4000-8000-000000000003	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
24	d1000001-0000-4000-8000-00000000001c	d2000003-0000-4000-8000-000000000001	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
25	d1000001-0000-4000-8000-00000000001d	d2000003-0000-4000-8000-000000000002	admin	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
26	d1000001-0000-4000-8000-00000000001e	d2000003-0000-4000-8000-000000000003	member	\N	\N	1	2026-02-25 11:38:31.570773+00	2026-02-25 11:38:31.570773+00	\N	\N	\N	\N	2026-02-25 11:38:31.570773+00	infinity	\N	\N
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.persons (id, email, cognito_sub, salesforce_contact_id, medusa_customer_id, cvent_contact_id, camp_contact_id, netsuite_entity_id, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, stripe_customer_id) FROM stdin;
d1000001-0000-4000-8000-000000000001	demo1@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000002	demo2@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000003	demo3@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000004	demo4@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000005	demo5@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000006	demo6@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000007	demo7@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000008	demo8@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000009	demo9@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000a	demo10@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000b	demo11@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000c	demo12@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000d	demo13@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000e	demo14@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000000f	demo15@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000010	demo16@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000011	demo17@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000012	demo18@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000013	demo19@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000014	demo20@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000015	demo21@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000016	demo22@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000017	demo23@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000018	demo24@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000019	demo25@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001a	demo26@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001b	demo27@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001c	demo28@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001d	demo29@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001e	demo30@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000001f	demo31@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000020	demo32@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000021	demo33@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000022	demo34@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000023	demo35@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000024	demo36@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000025	demo37@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000026	demo38@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000027	demo39@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000028	demo40@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000029	demo41@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000002a	demo42@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000002b	demo43@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000002c	demo44@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000002d	demo45@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000002e	demo46@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000002f	demo47@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000030	demo48@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000031	demo49@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000032	demo50@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000033	demo51@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000034	demo52@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000035	demo53@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000036	demo54@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000037	demo55@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000038	demo56@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000039	demo57@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000003a	demo58@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000003b	demo59@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000003c	demo60@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000003d	demo61@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-31 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000003e	demo62@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000003f	demo63@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000040	demo64@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000041	demo65@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-18 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000042	demo66@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000043	demo67@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000044	demo68@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000045	demo69@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000046	demo70@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000047	demo71@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000048	demo72@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000049	demo73@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000004a	demo74@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000004b	demo75@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000004c	demo76@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000004d	demo77@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000004e	demo78@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000004f	demo79@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-21 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000050	demo80@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000051	demo81@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000052	demo82@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000053	demo83@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000054	demo84@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000055	demo85@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000056	demo86@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000057	demo87@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000058	demo88@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000059	demo89@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000005a	demo90@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000005b	demo91@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000005c	demo92@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000005d	demo93@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000005e	demo94@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000005f	demo95@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000060	demo96@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000061	demo97@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000062	demo98@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000063	demo99@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000064	demo100@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000065	demo101@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000066	demo102@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000067	demo103@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000068	demo104@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-13 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000069	demo105@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000006a	demo106@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000006b	demo107@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000006c	demo108@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000006d	demo109@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000006e	demo110@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000006f	demo111@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000070	demo112@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000071	demo113@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000072	demo114@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000073	demo115@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000074	demo116@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000075	demo117@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000076	demo118@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-13 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000077	demo119@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000078	demo120@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000079	demo121@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000007a	demo122@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000007b	demo123@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-08 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000007c	demo124@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000007d	demo125@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000007e	demo126@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000007f	demo127@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000080	demo128@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000081	demo129@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000082	demo130@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000083	demo131@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000084	demo132@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000085	demo133@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000086	demo134@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000087	demo135@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000088	demo136@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000089	demo137@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000008a	demo138@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000008b	demo139@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000008c	demo140@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000008d	demo141@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000008e	demo142@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000008f	demo143@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000090	demo144@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000091	demo145@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000092	demo146@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000093	demo147@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000094	demo148@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000095	demo149@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-21 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000096	demo150@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000097	demo151@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000098	demo152@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-000000000099	demo153@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000009a	demo154@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000009b	demo155@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000009c	demo156@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000009d	demo157@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000009e	demo158@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-00000000009f	demo159@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a0	demo160@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a1	demo161@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a2	demo162@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a3	demo163@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a4	demo164@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a5	demo165@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a6	demo166@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a7	demo167@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a8	demo168@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000a9	demo169@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000aa	demo170@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000ab	demo171@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-13 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000ac	demo172@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-18 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000ad	demo173@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000ae	demo174@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000af	demo175@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b0	demo176@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b1	demo177@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b2	demo178@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-08 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b3	demo179@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b4	demo180@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b5	demo181@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b6	demo182@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b7	demo183@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b8	demo184@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000b9	demo185@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000ba	demo186@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000bb	demo187@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-18 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000bc	demo188@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000bd	demo189@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000be	demo190@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000bf	demo191@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c0	demo192@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c1	demo193@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c2	demo194@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c3	demo195@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c4	demo196@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c5	demo197@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c6	demo198@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c7	demo199@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c8	demo200@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000c9	demo201@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000ca	demo202@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000cb	demo203@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000cc	demo204@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000cd	demo205@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000ce	demo206@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000cf	demo207@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000d0	demo208@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000d1	demo209@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
d1000001-0000-4000-8000-0000000000d2	demo210@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	\N
\.


--
-- Data for Name: persons_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.persons_history (history_id, id, email, cognito_sub, salesforce_contact_id, medusa_customer_id, cvent_contact_id, camp_contact_id, netsuite_entity_id, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d1000001-0000-4000-8000-000000000001	demo1@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
2	d1000001-0000-4000-8000-000000000002	demo2@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
3	d1000001-0000-4000-8000-000000000003	demo3@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
4	d1000001-0000-4000-8000-000000000004	demo4@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
5	d1000001-0000-4000-8000-000000000005	demo5@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
6	d1000001-0000-4000-8000-000000000006	demo6@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
7	d1000001-0000-4000-8000-000000000007	demo7@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
8	d1000001-0000-4000-8000-000000000008	demo8@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
9	d1000001-0000-4000-8000-000000000009	demo9@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
10	d1000001-0000-4000-8000-00000000000a	demo10@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-25 11:38:31.410224+00	2026-02-25 11:38:31.410224+00	\N	\N	\N	\N	2026-02-25 11:38:31.410224+00	infinity	\N	\N
11	d1000001-0000-4000-8000-00000000000b	demo11@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-03 11:38:31.459797+00	infinity	\N	\N
12	d1000001-0000-4000-8000-00000000000c	demo12@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-29 11:38:31.459797+00	infinity	\N	\N
13	d1000001-0000-4000-8000-00000000000d	demo13@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-01 11:38:31.459797+00	infinity	\N	\N
14	d1000001-0000-4000-8000-00000000000e	demo14@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-05 11:38:31.459797+00	infinity	\N	\N
15	d1000001-0000-4000-8000-00000000000f	demo15@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-25 11:38:31.459797+00	infinity	\N	\N
16	d1000001-0000-4000-8000-000000000010	demo16@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-23 11:38:31.459797+00	infinity	\N	\N
17	d1000001-0000-4000-8000-000000000011	demo17@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-20 11:38:31.459797+00	infinity	\N	\N
18	d1000001-0000-4000-8000-000000000012	demo18@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-27 11:38:31.459797+00	infinity	\N	\N
19	d1000001-0000-4000-8000-000000000013	demo19@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-16 11:38:31.459797+00	infinity	\N	\N
20	d1000001-0000-4000-8000-000000000014	demo20@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-07 11:38:31.459797+00	infinity	\N	\N
21	d1000001-0000-4000-8000-000000000015	demo21@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-19 11:38:31.459797+00	infinity	\N	\N
22	d1000001-0000-4000-8000-000000000016	demo22@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-27 11:38:31.459797+00	infinity	\N	\N
23	d1000001-0000-4000-8000-000000000017	demo23@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-10 11:38:31.459797+00	infinity	\N	\N
24	d1000001-0000-4000-8000-000000000018	demo24@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-05 11:38:31.459797+00	infinity	\N	\N
25	d1000001-0000-4000-8000-000000000019	demo25@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-19 11:38:31.459797+00	infinity	\N	\N
26	d1000001-0000-4000-8000-00000000001a	demo26@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-16 11:38:31.459797+00	infinity	\N	\N
27	d1000001-0000-4000-8000-00000000001b	demo27@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-06 11:38:31.459797+00	infinity	\N	\N
28	d1000001-0000-4000-8000-00000000001c	demo28@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-28 11:38:31.459797+00	infinity	\N	\N
29	d1000001-0000-4000-8000-00000000001d	demo29@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-07 11:38:31.459797+00	infinity	\N	\N
30	d1000001-0000-4000-8000-00000000001e	demo30@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-19 11:38:31.459797+00	infinity	\N	\N
31	d1000001-0000-4000-8000-00000000001f	demo31@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-05 11:38:31.459797+00	infinity	\N	\N
32	d1000001-0000-4000-8000-000000000020	demo32@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-02 11:38:31.459797+00	infinity	\N	\N
33	d1000001-0000-4000-8000-000000000021	demo33@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-12 11:38:31.459797+00	infinity	\N	\N
34	d1000001-0000-4000-8000-000000000022	demo34@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-22 11:38:31.459797+00	infinity	\N	\N
35	d1000001-0000-4000-8000-000000000023	demo35@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-29 11:38:31.459797+00	infinity	\N	\N
36	d1000001-0000-4000-8000-000000000024	demo36@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-19 11:38:31.459797+00	infinity	\N	\N
37	d1000001-0000-4000-8000-000000000025	demo37@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-12 11:38:31.459797+00	infinity	\N	\N
38	d1000001-0000-4000-8000-000000000026	demo38@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-23 11:38:31.459797+00	infinity	\N	\N
39	d1000001-0000-4000-8000-000000000027	demo39@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-12 11:38:31.459797+00	infinity	\N	\N
40	d1000001-0000-4000-8000-000000000028	demo40@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-09 11:38:31.459797+00	infinity	\N	\N
41	d1000001-0000-4000-8000-000000000029	demo41@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-16 11:38:31.459797+00	infinity	\N	\N
42	d1000001-0000-4000-8000-00000000002a	demo42@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-05 11:38:31.459797+00	infinity	\N	\N
43	d1000001-0000-4000-8000-00000000002b	demo43@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-17 11:38:31.459797+00	infinity	\N	\N
44	d1000001-0000-4000-8000-00000000002c	demo44@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-05 11:38:31.459797+00	infinity	\N	\N
45	d1000001-0000-4000-8000-00000000002d	demo45@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-16 11:38:31.459797+00	infinity	\N	\N
46	d1000001-0000-4000-8000-00000000002e	demo46@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-12 11:38:31.459797+00	infinity	\N	\N
47	d1000001-0000-4000-8000-00000000002f	demo47@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-27 11:38:31.459797+00	infinity	\N	\N
48	d1000001-0000-4000-8000-000000000030	demo48@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-26 11:38:31.459797+00	infinity	\N	\N
49	d1000001-0000-4000-8000-000000000031	demo49@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-03 11:38:31.459797+00	infinity	\N	\N
50	d1000001-0000-4000-8000-000000000032	demo50@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-12 11:38:31.459797+00	infinity	\N	\N
51	d1000001-0000-4000-8000-000000000033	demo51@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-24 11:38:31.459797+00	infinity	\N	\N
52	d1000001-0000-4000-8000-000000000034	demo52@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-05 11:38:31.459797+00	infinity	\N	\N
53	d1000001-0000-4000-8000-000000000035	demo53@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-24 11:38:31.459797+00	infinity	\N	\N
54	d1000001-0000-4000-8000-000000000036	demo54@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-17 11:38:31.459797+00	infinity	\N	\N
55	d1000001-0000-4000-8000-000000000037	demo55@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-07 11:38:31.459797+00	infinity	\N	\N
56	d1000001-0000-4000-8000-000000000038	demo56@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-15 11:38:31.459797+00	infinity	\N	\N
57	d1000001-0000-4000-8000-000000000039	demo57@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-14 11:38:31.459797+00	infinity	\N	\N
58	d1000001-0000-4000-8000-00000000003a	demo58@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-30 11:38:31.459797+00	infinity	\N	\N
59	d1000001-0000-4000-8000-00000000003b	demo59@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-07 11:38:31.459797+00	infinity	\N	\N
60	d1000001-0000-4000-8000-00000000003c	demo60@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-05 11:38:31.459797+00	infinity	\N	\N
61	d1000001-0000-4000-8000-00000000003d	demo61@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-31 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-31 11:38:31.459797+00	infinity	\N	\N
62	d1000001-0000-4000-8000-00000000003e	demo62@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-30 11:38:31.459797+00	infinity	\N	\N
63	d1000001-0000-4000-8000-00000000003f	demo63@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-17 11:38:31.459797+00	infinity	\N	\N
64	d1000001-0000-4000-8000-000000000040	demo64@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-16 11:38:31.459797+00	infinity	\N	\N
65	d1000001-0000-4000-8000-000000000041	demo65@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-18 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-18 11:38:31.459797+00	infinity	\N	\N
66	d1000001-0000-4000-8000-000000000042	demo66@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-28 11:38:31.459797+00	infinity	\N	\N
67	d1000001-0000-4000-8000-000000000043	demo67@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-12 11:38:31.459797+00	infinity	\N	\N
68	d1000001-0000-4000-8000-000000000044	demo68@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-01 11:38:31.459797+00	infinity	\N	\N
69	d1000001-0000-4000-8000-000000000045	demo69@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-03 11:38:31.459797+00	infinity	\N	\N
70	d1000001-0000-4000-8000-000000000046	demo70@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-09 11:38:31.459797+00	infinity	\N	\N
71	d1000001-0000-4000-8000-000000000047	demo71@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-12 11:38:31.459797+00	infinity	\N	\N
72	d1000001-0000-4000-8000-000000000048	demo72@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-25 11:38:31.459797+00	infinity	\N	\N
73	d1000001-0000-4000-8000-000000000049	demo73@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-15 11:38:31.459797+00	infinity	\N	\N
74	d1000001-0000-4000-8000-00000000004a	demo74@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-25 11:38:31.459797+00	infinity	\N	\N
75	d1000001-0000-4000-8000-00000000004b	demo75@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-29 11:38:31.459797+00	infinity	\N	\N
76	d1000001-0000-4000-8000-00000000004c	demo76@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-01 11:38:31.459797+00	infinity	\N	\N
77	d1000001-0000-4000-8000-00000000004d	demo77@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-03 11:38:31.459797+00	infinity	\N	\N
78	d1000001-0000-4000-8000-00000000004e	demo78@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-06 11:38:31.459797+00	infinity	\N	\N
79	d1000001-0000-4000-8000-00000000004f	demo79@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-21 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-21 11:38:31.459797+00	infinity	\N	\N
80	d1000001-0000-4000-8000-000000000050	demo80@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-07 11:38:31.459797+00	infinity	\N	\N
81	d1000001-0000-4000-8000-000000000051	demo81@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-04 11:38:31.459797+00	infinity	\N	\N
82	d1000001-0000-4000-8000-000000000052	demo82@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-01 11:38:31.459797+00	infinity	\N	\N
83	d1000001-0000-4000-8000-000000000053	demo83@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-17 11:38:31.459797+00	infinity	\N	\N
84	d1000001-0000-4000-8000-000000000054	demo84@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-20 11:38:31.459797+00	infinity	\N	\N
85	d1000001-0000-4000-8000-000000000055	demo85@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-05 11:38:31.459797+00	infinity	\N	\N
86	d1000001-0000-4000-8000-000000000056	demo86@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-14 11:38:31.459797+00	infinity	\N	\N
87	d1000001-0000-4000-8000-000000000057	demo87@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-19 11:38:31.459797+00	infinity	\N	\N
88	d1000001-0000-4000-8000-000000000058	demo88@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-19 11:38:31.459797+00	infinity	\N	\N
89	d1000001-0000-4000-8000-000000000059	demo89@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-04 11:38:31.459797+00	infinity	\N	\N
90	d1000001-0000-4000-8000-00000000005a	demo90@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-24 11:38:31.459797+00	infinity	\N	\N
91	d1000001-0000-4000-8000-00000000005b	demo91@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-25 11:38:31.459797+00	infinity	\N	\N
92	d1000001-0000-4000-8000-00000000005c	demo92@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-20 11:38:31.459797+00	infinity	\N	\N
93	d1000001-0000-4000-8000-00000000005d	demo93@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-26 11:38:31.459797+00	infinity	\N	\N
94	d1000001-0000-4000-8000-00000000005e	demo94@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-24 11:38:31.459797+00	infinity	\N	\N
95	d1000001-0000-4000-8000-00000000005f	demo95@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-07 11:38:31.459797+00	infinity	\N	\N
96	d1000001-0000-4000-8000-000000000060	demo96@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-26 11:38:31.459797+00	infinity	\N	\N
97	d1000001-0000-4000-8000-000000000061	demo97@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-07 11:38:31.459797+00	infinity	\N	\N
98	d1000001-0000-4000-8000-000000000062	demo98@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-27 11:38:31.459797+00	infinity	\N	\N
99	d1000001-0000-4000-8000-000000000063	demo99@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-12 11:38:31.459797+00	infinity	\N	\N
100	d1000001-0000-4000-8000-000000000064	demo100@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-07 11:38:31.459797+00	infinity	\N	\N
101	d1000001-0000-4000-8000-000000000065	demo101@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-03 11:38:31.459797+00	infinity	\N	\N
102	d1000001-0000-4000-8000-000000000066	demo102@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-19 11:38:31.459797+00	infinity	\N	\N
103	d1000001-0000-4000-8000-000000000067	demo103@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-01 11:38:31.459797+00	infinity	\N	\N
104	d1000001-0000-4000-8000-000000000068	demo104@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-13 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-13 11:38:31.459797+00	infinity	\N	\N
105	d1000001-0000-4000-8000-000000000069	demo105@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-10 11:38:31.459797+00	infinity	\N	\N
106	d1000001-0000-4000-8000-00000000006a	demo106@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-20 11:38:31.459797+00	infinity	\N	\N
107	d1000001-0000-4000-8000-00000000006b	demo107@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-29 11:38:31.459797+00	infinity	\N	\N
108	d1000001-0000-4000-8000-00000000006c	demo108@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-10 11:38:31.459797+00	infinity	\N	\N
109	d1000001-0000-4000-8000-00000000006d	demo109@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-07 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-07 11:38:31.459797+00	infinity	\N	\N
110	d1000001-0000-4000-8000-00000000006e	demo110@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-16 11:38:31.459797+00	infinity	\N	\N
111	d1000001-0000-4000-8000-00000000006f	demo111@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-16 11:38:31.459797+00	infinity	\N	\N
112	d1000001-0000-4000-8000-000000000070	demo112@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-30 11:38:31.459797+00	infinity	\N	\N
113	d1000001-0000-4000-8000-000000000071	demo113@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-22 11:38:31.459797+00	infinity	\N	\N
114	d1000001-0000-4000-8000-000000000072	demo114@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-22 11:38:31.459797+00	infinity	\N	\N
115	d1000001-0000-4000-8000-000000000073	demo115@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-14 11:38:31.459797+00	infinity	\N	\N
116	d1000001-0000-4000-8000-000000000074	demo116@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-05 11:38:31.459797+00	infinity	\N	\N
117	d1000001-0000-4000-8000-000000000075	demo117@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-02 11:38:31.459797+00	infinity	\N	\N
118	d1000001-0000-4000-8000-000000000076	demo118@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-13 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-13 11:38:31.459797+00	infinity	\N	\N
119	d1000001-0000-4000-8000-000000000077	demo119@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-11 11:38:31.459797+00	infinity	\N	\N
120	d1000001-0000-4000-8000-000000000078	demo120@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-25 11:38:31.459797+00	infinity	\N	\N
121	d1000001-0000-4000-8000-000000000079	demo121@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-05 11:38:31.459797+00	infinity	\N	\N
122	d1000001-0000-4000-8000-00000000007a	demo122@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-25 11:38:31.459797+00	infinity	\N	\N
123	d1000001-0000-4000-8000-00000000007b	demo123@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-08 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-08 11:38:31.459797+00	infinity	\N	\N
124	d1000001-0000-4000-8000-00000000007c	demo124@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-30 11:38:31.459797+00	infinity	\N	\N
125	d1000001-0000-4000-8000-00000000007d	demo125@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-29 11:38:31.459797+00	infinity	\N	\N
126	d1000001-0000-4000-8000-00000000007e	demo126@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-15 11:38:31.459797+00	infinity	\N	\N
127	d1000001-0000-4000-8000-00000000007f	demo127@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-27 11:38:31.459797+00	infinity	\N	\N
128	d1000001-0000-4000-8000-000000000080	demo128@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-24 11:38:31.459797+00	infinity	\N	\N
129	d1000001-0000-4000-8000-000000000081	demo129@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-10 11:38:31.459797+00	infinity	\N	\N
130	d1000001-0000-4000-8000-000000000082	demo130@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-28 11:38:31.459797+00	infinity	\N	\N
131	d1000001-0000-4000-8000-000000000083	demo131@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-10 11:38:31.459797+00	infinity	\N	\N
132	d1000001-0000-4000-8000-000000000084	demo132@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-12 11:38:31.459797+00	infinity	\N	\N
133	d1000001-0000-4000-8000-000000000085	demo133@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-25 11:38:31.459797+00	infinity	\N	\N
134	d1000001-0000-4000-8000-000000000086	demo134@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-22 11:38:31.459797+00	infinity	\N	\N
135	d1000001-0000-4000-8000-000000000087	demo135@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-10 11:38:31.459797+00	infinity	\N	\N
136	d1000001-0000-4000-8000-000000000088	demo136@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-29 11:38:31.459797+00	infinity	\N	\N
137	d1000001-0000-4000-8000-000000000089	demo137@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-22 11:38:31.459797+00	infinity	\N	\N
138	d1000001-0000-4000-8000-00000000008a	demo138@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-17 11:38:31.459797+00	infinity	\N	\N
139	d1000001-0000-4000-8000-00000000008b	demo139@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-09 11:38:31.459797+00	infinity	\N	\N
140	d1000001-0000-4000-8000-00000000008c	demo140@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-01 11:38:31.459797+00	infinity	\N	\N
141	d1000001-0000-4000-8000-00000000008d	demo141@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-15 11:38:31.459797+00	infinity	\N	\N
142	d1000001-0000-4000-8000-00000000008e	demo142@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-02 11:38:31.459797+00	infinity	\N	\N
143	d1000001-0000-4000-8000-00000000008f	demo143@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-24 11:38:31.459797+00	infinity	\N	\N
144	d1000001-0000-4000-8000-000000000090	demo144@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-03 11:38:31.459797+00	infinity	\N	\N
145	d1000001-0000-4000-8000-000000000091	demo145@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-20 11:38:31.459797+00	infinity	\N	\N
146	d1000001-0000-4000-8000-000000000092	demo146@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-01 11:38:31.459797+00	infinity	\N	\N
147	d1000001-0000-4000-8000-000000000093	demo147@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-23 11:38:31.459797+00	infinity	\N	\N
148	d1000001-0000-4000-8000-000000000094	demo148@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-01 11:38:31.459797+00	infinity	\N	\N
149	d1000001-0000-4000-8000-000000000095	demo149@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-21 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-21 11:38:31.459797+00	infinity	\N	\N
150	d1000001-0000-4000-8000-000000000096	demo150@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-27 11:38:31.459797+00	infinity	\N	\N
151	d1000001-0000-4000-8000-000000000097	demo151@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-10 11:38:31.459797+00	infinity	\N	\N
152	d1000001-0000-4000-8000-000000000098	demo152@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-28 11:38:31.459797+00	infinity	\N	\N
153	d1000001-0000-4000-8000-000000000099	demo153@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-20 11:38:31.459797+00	infinity	\N	\N
154	d1000001-0000-4000-8000-00000000009a	demo154@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-02 11:38:31.459797+00	infinity	\N	\N
155	d1000001-0000-4000-8000-00000000009b	demo155@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-11 11:38:31.459797+00	infinity	\N	\N
156	d1000001-0000-4000-8000-00000000009c	demo156@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-11 11:38:31.459797+00	infinity	\N	\N
157	d1000001-0000-4000-8000-00000000009d	demo157@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-05 11:38:31.459797+00	infinity	\N	\N
158	d1000001-0000-4000-8000-00000000009e	demo158@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-15 11:38:31.459797+00	infinity	\N	\N
159	d1000001-0000-4000-8000-00000000009f	demo159@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-23 11:38:31.459797+00	infinity	\N	\N
160	d1000001-0000-4000-8000-0000000000a0	demo160@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-29 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-29 11:38:31.459797+00	infinity	\N	\N
161	d1000001-0000-4000-8000-0000000000a1	demo161@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-06 11:38:31.459797+00	infinity	\N	\N
162	d1000001-0000-4000-8000-0000000000a2	demo162@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-12 11:38:31.459797+00	infinity	\N	\N
163	d1000001-0000-4000-8000-0000000000a3	demo163@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-20 11:38:31.459797+00	infinity	\N	\N
164	d1000001-0000-4000-8000-0000000000a4	demo164@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-23 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-23 11:38:31.459797+00	infinity	\N	\N
165	d1000001-0000-4000-8000-0000000000a5	demo165@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-04 11:38:31.459797+00	infinity	\N	\N
166	d1000001-0000-4000-8000-0000000000a6	demo166@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-27 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-27 11:38:31.459797+00	infinity	\N	\N
167	d1000001-0000-4000-8000-0000000000a7	demo167@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-16 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-16 11:38:31.459797+00	infinity	\N	\N
168	d1000001-0000-4000-8000-0000000000a8	demo168@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-10 11:38:31.459797+00	infinity	\N	\N
169	d1000001-0000-4000-8000-0000000000a9	demo169@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-30 11:38:31.459797+00	infinity	\N	\N
170	d1000001-0000-4000-8000-0000000000aa	demo170@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-17 11:38:31.459797+00	infinity	\N	\N
171	d1000001-0000-4000-8000-0000000000ab	demo171@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-13 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-13 11:38:31.459797+00	infinity	\N	\N
172	d1000001-0000-4000-8000-0000000000ac	demo172@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-18 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-18 11:38:31.459797+00	infinity	\N	\N
173	d1000001-0000-4000-8000-0000000000ad	demo173@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-30 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-30 11:38:31.459797+00	infinity	\N	\N
174	d1000001-0000-4000-8000-0000000000ae	demo174@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-24 11:38:31.459797+00	infinity	\N	\N
175	d1000001-0000-4000-8000-0000000000af	demo175@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-03 11:38:31.459797+00	infinity	\N	\N
176	d1000001-0000-4000-8000-0000000000b0	demo176@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-05 11:38:31.459797+00	infinity	\N	\N
177	d1000001-0000-4000-8000-0000000000b1	demo177@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-10 11:38:31.459797+00	infinity	\N	\N
178	d1000001-0000-4000-8000-0000000000b2	demo178@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-08 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-08 11:38:31.459797+00	infinity	\N	\N
179	d1000001-0000-4000-8000-0000000000b3	demo179@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-06 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-06 11:38:31.459797+00	infinity	\N	\N
180	d1000001-0000-4000-8000-0000000000b4	demo180@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-05 11:38:31.459797+00	infinity	\N	\N
181	d1000001-0000-4000-8000-0000000000b5	demo181@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-14 11:38:31.459797+00	infinity	\N	\N
182	d1000001-0000-4000-8000-0000000000b6	demo182@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-11 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-11 11:38:31.459797+00	infinity	\N	\N
183	d1000001-0000-4000-8000-0000000000b7	demo183@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-09 11:38:31.459797+00	infinity	\N	\N
184	d1000001-0000-4000-8000-0000000000b8	demo184@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-12 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-12 11:38:31.459797+00	infinity	\N	\N
185	d1000001-0000-4000-8000-0000000000b9	demo185@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-05 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-05 11:38:31.459797+00	infinity	\N	\N
186	d1000001-0000-4000-8000-0000000000ba	demo186@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-06-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-06-09 11:38:31.459797+00	infinity	\N	\N
187	d1000001-0000-4000-8000-0000000000bb	demo187@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-18 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-18 11:38:31.459797+00	infinity	\N	\N
188	d1000001-0000-4000-8000-0000000000bc	demo188@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-24 11:38:31.459797+00	infinity	\N	\N
189	d1000001-0000-4000-8000-0000000000bd	demo189@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-22 11:38:31.459797+00	infinity	\N	\N
190	d1000001-0000-4000-8000-0000000000be	demo190@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-03 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-03 11:38:31.459797+00	infinity	\N	\N
191	d1000001-0000-4000-8000-0000000000bf	demo191@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-02 11:38:31.459797+00	infinity	\N	\N
192	d1000001-0000-4000-8000-0000000000c0	demo192@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-10 11:38:31.459797+00	infinity	\N	\N
193	d1000001-0000-4000-8000-0000000000c1	demo193@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-09 11:38:31.459797+00	infinity	\N	\N
194	d1000001-0000-4000-8000-0000000000c2	demo194@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-20 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-20 11:38:31.459797+00	infinity	\N	\N
195	d1000001-0000-4000-8000-0000000000c3	demo195@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-04-24 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-04-24 11:38:31.459797+00	infinity	\N	\N
196	d1000001-0000-4000-8000-0000000000c4	demo196@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-08-28 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-08-28 11:38:31.459797+00	infinity	\N	\N
197	d1000001-0000-4000-8000-0000000000c5	demo197@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-17 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-17 11:38:31.459797+00	infinity	\N	\N
198	d1000001-0000-4000-8000-0000000000c6	demo198@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-19 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-19 11:38:31.459797+00	infinity	\N	\N
199	d1000001-0000-4000-8000-0000000000c7	demo199@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-07-02 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-07-02 11:38:31.459797+00	infinity	\N	\N
200	d1000001-0000-4000-8000-0000000000c8	demo200@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-26 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-26 11:38:31.459797+00	infinity	\N	\N
201	d1000001-0000-4000-8000-0000000000c9	demo201@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-12-22 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-12-22 11:38:31.459797+00	infinity	\N	\N
202	d1000001-0000-4000-8000-0000000000ca	demo202@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-05-01 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-05-01 11:38:31.459797+00	infinity	\N	\N
203	d1000001-0000-4000-8000-0000000000cb	demo203@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-25 11:38:31.459797+00	infinity	\N	\N
204	d1000001-0000-4000-8000-0000000000cc	demo204@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-11-25 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-11-25 11:38:31.459797+00	infinity	\N	\N
205	d1000001-0000-4000-8000-0000000000cd	demo205@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-14 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-14 11:38:31.459797+00	infinity	\N	\N
206	d1000001-0000-4000-8000-0000000000ce	demo206@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-09-09 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-09-09 11:38:31.459797+00	infinity	\N	\N
207	d1000001-0000-4000-8000-0000000000cf	demo207@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-03-15 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-03-15 11:38:31.459797+00	infinity	\N	\N
208	d1000001-0000-4000-8000-0000000000d0	demo208@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2025-10-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2025-10-10 11:38:31.459797+00	infinity	\N	\N
209	d1000001-0000-4000-8000-0000000000d1	demo209@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-02-10 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-02-10 11:38:31.459797+00	infinity	\N	\N
210	d1000001-0000-4000-8000-0000000000d2	demo210@metabase-demo.example.com	\N	\N	\N	\N	\N	\N	1	2026-01-04 11:38:31.459797+00	2026-02-25 11:38:31.459797+00	\N	\N	\N	\N	2026-01-04 11:38:31.459797+00	infinity	\N	\N
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.products (id, sku, name, description, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, category) FROM stdin;
d2000001-0000-4000-8000-000000000001	demo_membership	Demo Membership	Demo product for Phase 6 reports	1	2026-02-25 11:38:31.427969+00	2026-02-25 11:38:31.427969+00	\N	\N	\N	\N	\N
d2000001-0000-4000-8000-000000000002	demo_seats	Demo Seat Pools	Org seat product for utilization reports	1	2026-02-25 11:38:31.427969+00	2026-02-25 11:38:31.427969+00	\N	\N	\N	\N	\N
\.


--
-- Data for Name: products_history; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.products_history (history_id, id, sku, name, description, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via, valid_from, valid_to, changed_by_id, changed_via) FROM stdin;
1	d2000001-0000-4000-8000-000000000001	demo_membership	Demo Membership	Demo product for Phase 6 reports	1	2026-02-25 11:38:31.427969+00	2026-02-25 11:38:31.427969+00	\N	\N	\N	\N	2026-02-25 11:38:31.427969+00	infinity	\N	\N
2	d2000001-0000-4000-8000-000000000002	demo_seats	Demo Seat Pools	Org seat product for utilization reports	1	2026-02-25 11:38:31.427969+00	2026-02-25 11:38:31.427969+00	\N	\N	\N	\N	2026-02-25 11:38:31.427969+00	infinity	\N	\N
\.


--
-- Data for Name: stripe_events; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.stripe_events (id, stripe_event_id, type, status, error_message, created_at, processed_at) FROM stdin;
1	demo_evt_001	customer.subscription.created	processed	\N	2026-02-24 11:38:31.584821+00	2026-02-24 11:38:31.584821+00
2	demo_evt_002	invoice.paid	processed	\N	2026-02-25 09:38:31.584821+00	2026-02-25 09:38:31.584821+00
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: apiary
--

COPY public.subscriptions (id, membership_plan_id, person_id, organization_id, scope_type, status, stripe_subscription_id, stripe_customer_id, current_period_start, current_period_end, cancel_at_period_end, canceled_at, trial_end, version, created_at, updated_at, created_by_id, created_via, updated_by_id, updated_via) FROM stdin;
d2000004-0000-4000-8000-000000000001	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000001	\N	person	active	demo_sub_01	\N	2026-02-10 11:38:31.435744+00	2026-03-12 11:38:31.435744+00	f	\N	\N	1	2025-12-25 11:38:31.435744+00	2026-02-25 11:38:31.435744+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000002	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000002	\N	person	active	demo_sub_02	\N	2026-01-25 11:38:31.435744+00	2027-01-25 11:38:31.435744+00	f	\N	\N	1	2025-11-25 11:38:31.435744+00	2026-02-25 11:38:31.435744+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000003	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000003	\N	person	trialing	demo_sub_03	\N	2026-02-25 11:38:31.435744+00	2026-03-11 11:38:31.435744+00	f	\N	\N	1	2026-02-25 11:38:31.435744+00	2026-02-25 11:38:31.435744+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000004	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000004	\N	person	active	demo_sub_04	\N	2026-02-20 11:38:31.435744+00	2026-03-22 11:38:31.435744+00	t	\N	\N	1	2026-01-25 11:38:31.435744+00	2026-02-25 11:38:31.435744+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000005	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000005	\N	person	canceled	demo_sub_05	\N	2025-12-27 11:38:31.435744+00	2026-01-26 11:38:31.435744+00	f	2026-01-26 11:38:31.435744+00	\N	1	2025-10-25 11:38:31.435744+00	2026-02-25 11:38:31.435744+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000006	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000006	\N	person	canceled	demo_sub_06	\N	2025-11-27 11:38:31.435744+00	2025-12-27 11:38:31.435744+00	f	2025-12-27 11:38:31.435744+00	\N	1	2025-09-25 11:38:31.435744+00	2026-02-25 11:38:31.435744+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000065	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000000c	\N	person	active	demo_sub_101	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-02-21 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000066	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000000d	\N	person	trialing	demo_sub_102	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-02-17 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000067	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000000e	\N	person	canceled	demo_sub_103	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2026-02-13 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000068	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000000f	\N	person	active	demo_sub_104	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-02-09 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000069	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000010	\N	person	active	demo_sub_105	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2026-02-05 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000006a	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000011	\N	person	trialing	demo_sub_106	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-02-01 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000006b	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000012	\N	person	canceled	demo_sub_107	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2026-01-28 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000006c	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000013	\N	person	active	demo_sub_108	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-01-24 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000006d	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000014	\N	person	active	demo_sub_109	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-01-20 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000006e	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000015	\N	person	trialing	demo_sub_110	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2026-01-16 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000006f	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000016	\N	person	canceled	demo_sub_111	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2026-01-12 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000070	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000017	\N	person	active	demo_sub_112	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-01-08 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000071	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000018	\N	person	active	demo_sub_113	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2026-01-04 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000072	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000019	\N	person	trialing	demo_sub_114	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-12-31 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000073	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000001a	\N	person	canceled	demo_sub_115	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	t	2026-01-26 11:38:31.552109+00	\N	1	2025-12-27 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000074	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000001b	\N	person	active	demo_sub_116	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-12-23 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000075	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000001c	\N	person	active	demo_sub_117	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-12-19 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000076	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000001d	\N	person	trialing	demo_sub_118	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-12-15 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000077	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000001e	\N	person	canceled	demo_sub_119	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-12-11 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000078	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000001f	\N	person	active	demo_sub_120	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-12-07 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000079	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000020	\N	person	active	demo_sub_121	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-12-03 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000007a	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000021	\N	person	trialing	demo_sub_122	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-11-29 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000007b	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000022	\N	person	canceled	demo_sub_123	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-11-25 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000007c	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000023	\N	person	active	demo_sub_124	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-11-21 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000007d	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000024	\N	person	active	demo_sub_125	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-11-17 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000007e	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000025	\N	person	trialing	demo_sub_126	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-11-13 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000007f	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000026	\N	person	canceled	demo_sub_127	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-11-09 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000080	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000027	\N	person	active	demo_sub_128	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-11-05 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000081	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000028	\N	person	active	demo_sub_129	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-11-01 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000082	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000029	\N	person	trialing	demo_sub_130	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-10-28 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000083	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000002a	\N	person	canceled	demo_sub_131	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-10-24 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000084	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000002b	\N	person	active	demo_sub_132	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-10-20 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000085	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000002c	\N	person	active	demo_sub_133	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-10-16 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000086	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000002d	\N	person	trialing	demo_sub_134	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-10-12 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000087	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000002e	\N	person	canceled	demo_sub_135	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	t	2026-01-26 11:38:31.552109+00	\N	1	2025-10-08 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000088	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000002f	\N	person	active	demo_sub_136	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-10-04 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000089	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000030	\N	person	active	demo_sub_137	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-09-30 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000008a	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000031	\N	person	trialing	demo_sub_138	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-09-26 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000008b	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000032	\N	person	canceled	demo_sub_139	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-09-22 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000008c	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000033	\N	person	active	demo_sub_140	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-09-18 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000008d	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000034	\N	person	active	demo_sub_141	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-09-14 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000008e	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000035	\N	person	trialing	demo_sub_142	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-09-10 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000008f	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000036	\N	person	canceled	demo_sub_143	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-09-06 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000090	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000037	\N	person	active	demo_sub_144	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-09-02 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000091	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000038	\N	person	active	demo_sub_145	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-08-29 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000092	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000039	\N	person	trialing	demo_sub_146	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-08-25 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000093	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000003a	\N	person	canceled	demo_sub_147	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-08-21 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000094	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000003b	\N	person	active	demo_sub_148	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-08-17 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000095	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000003c	\N	person	active	demo_sub_149	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-08-13 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000096	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000003d	\N	person	trialing	demo_sub_150	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-08-09 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000097	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000003e	\N	person	canceled	demo_sub_151	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-08-05 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000098	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000003f	\N	person	active	demo_sub_152	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-08-01 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-000000000099	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000040	\N	person	active	demo_sub_153	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-07-28 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000009a	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000041	\N	person	trialing	demo_sub_154	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-07-24 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000009b	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000042	\N	person	canceled	demo_sub_155	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	t	2026-01-26 11:38:31.552109+00	\N	1	2025-07-20 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000009c	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000043	\N	person	active	demo_sub_156	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-07-16 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000009d	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000044	\N	person	active	demo_sub_157	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-07-12 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000009e	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000045	\N	person	trialing	demo_sub_158	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-07-08 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-00000000009f	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000046	\N	person	canceled	demo_sub_159	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-07-04 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a0	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000047	\N	person	active	demo_sub_160	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-06-30 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a1	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000048	\N	person	active	demo_sub_161	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-06-26 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a2	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000049	\N	person	trialing	demo_sub_162	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-06-22 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a3	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000004a	\N	person	canceled	demo_sub_163	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-06-18 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a4	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000004b	\N	person	active	demo_sub_164	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-06-14 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a5	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000004c	\N	person	active	demo_sub_165	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-06-10 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a6	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000004d	\N	person	trialing	demo_sub_166	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-06-06 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a7	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000004e	\N	person	canceled	demo_sub_167	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-06-02 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a8	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000004f	\N	person	active	demo_sub_168	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-05-29 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000a9	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000050	\N	person	active	demo_sub_169	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-05-25 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000aa	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000051	\N	person	trialing	demo_sub_170	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-05-21 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000ab	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000052	\N	person	canceled	demo_sub_171	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-05-17 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000ac	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000053	\N	person	active	demo_sub_172	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-05-13 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000ad	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000054	\N	person	active	demo_sub_173	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-05-09 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000ae	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000055	\N	person	trialing	demo_sub_174	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-05-05 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000af	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000056	\N	person	canceled	demo_sub_175	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	t	2026-01-26 11:38:31.552109+00	\N	1	2025-05-01 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000b0	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000057	\N	person	active	demo_sub_176	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-04-27 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000b1	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-000000000058	\N	person	active	demo_sub_177	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-04-23 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000b2	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-000000000059	\N	person	trialing	demo_sub_178	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	f	\N	\N	1	2025-04-19 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000b3	d2000002-0000-4000-8000-000000000002	d1000001-0000-4000-8000-00000000005a	\N	person	canceled	demo_sub_179	\N	2025-12-27 11:38:31.552109+00	2026-01-26 11:38:31.552109+00	f	2026-01-26 11:38:31.552109+00	\N	1	2025-04-15 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
d2000004-0000-4000-8000-0000000000b4	d2000002-0000-4000-8000-000000000001	d1000001-0000-4000-8000-00000000005b	\N	person	active	demo_sub_180	\N	2026-02-10 11:38:31.552109+00	2026-03-12 11:38:31.552109+00	t	\N	\N	1	2025-04-11 11:38:31.552109+00	2026-02-25 11:38:31.552109+00	\N	\N	\N	\N
\.


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: audit; Owner: apiary
--

SELECT pg_catalog.setval('audit.events_id_seq', 1, false);


--
-- Name: contributor_profiles_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.contributor_profiles_history_history_id_seq', 3, true);


--
-- Name: entitlements_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.entitlements_history_history_id_seq', 46, true);


--
-- Name: memberships_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.memberships_history_history_id_seq', 10, true);


--
-- Name: organization_membership_pools_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.organization_membership_pools_history_history_id_seq', 3, true);


--
-- Name: organizations_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.organizations_history_history_id_seq', 3, true);


--
-- Name: person_entitlements_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.person_entitlements_history_history_id_seq', 46, true);


--
-- Name: person_memberships_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.person_memberships_history_history_id_seq', 10, true);


--
-- Name: person_organizations_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.person_organizations_history_history_id_seq', 26, true);


--
-- Name: persons_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.persons_history_history_id_seq', 210, true);


--
-- Name: products_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.products_history_history_id_seq', 2, true);


--
-- Name: stripe_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apiary
--

SELECT pg_catalog.setval('public.stripe_events_id_seq', 2, true);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: audit; Owner: apiary
--

ALTER TABLE ONLY audit.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: big_commerce_orders big_commerce_orders_order_id_key; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.big_commerce_orders
    ADD CONSTRAINT big_commerce_orders_order_id_key UNIQUE (order_id);


--
-- Name: big_commerce_orders big_commerce_orders_pkey; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.big_commerce_orders
    ADD CONSTRAINT big_commerce_orders_pkey PRIMARY KEY (id);


--
-- Name: certification_records certification_records_pkey; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.certification_records
    ADD CONSTRAINT certification_records_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profiles linkedin_profiles_linkedin_id_key; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.linkedin_profiles
    ADD CONSTRAINT linkedin_profiles_linkedin_id_key UNIQUE (linkedin_id);


--
-- Name: linkedin_profiles linkedin_profiles_pkey; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.linkedin_profiles
    ADD CONSTRAINT linkedin_profiles_pkey PRIMARY KEY (id);


--
-- Name: salesforce_contacts salesforce_contacts_pkey; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.salesforce_contacts
    ADD CONSTRAINT salesforce_contacts_pkey PRIMARY KEY (id);


--
-- Name: salesforce_contacts salesforce_contacts_salesforce_id_key; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.salesforce_contacts
    ADD CONSTRAINT salesforce_contacts_salesforce_id_key UNIQUE (salesforce_id);


--
-- Name: salesforce_opportunities salesforce_opportunities_pkey; Type: CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.salesforce_opportunities
    ADD CONSTRAINT salesforce_opportunities_pkey PRIMARY KEY (id);


--
-- Name: contributor_engagement contributor_engagement_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_engagement
    ADD CONSTRAINT contributor_engagement_pkey PRIMARY KEY (id);


--
-- Name: contributor_profiles_history contributor_profiles_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_profiles_history
    ADD CONSTRAINT contributor_profiles_history_pkey PRIMARY KEY (history_id);


--
-- Name: contributor_profiles contributor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_profiles
    ADD CONSTRAINT contributor_profiles_pkey PRIMARY KEY (person_id);


--
-- Name: contributor_types contributor_types_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_types
    ADD CONSTRAINT contributor_types_pkey PRIMARY KEY (code);


--
-- Name: engagement_types engagement_types_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.engagement_types
    ADD CONSTRAINT engagement_types_pkey PRIMARY KEY (code);


--
-- Name: entitlements_history entitlements_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements_history
    ADD CONSTRAINT entitlements_history_pkey PRIMARY KEY (history_id);


--
-- Name: entitlements entitlements_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements
    ADD CONSTRAINT entitlements_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: membership_plans membership_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.membership_plans
    ADD CONSTRAINT membership_plans_pkey PRIMARY KEY (id);


--
-- Name: memberships_history memberships_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.memberships_history
    ADD CONSTRAINT memberships_history_pkey PRIMARY KEY (history_id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: organization_invites organization_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_invites
    ADD CONSTRAINT organization_invites_pkey PRIMARY KEY (id);


--
-- Name: organization_membership_pools_history organization_membership_pools_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_membership_pools_history
    ADD CONSTRAINT organization_membership_pools_history_pkey PRIMARY KEY (history_id);


--
-- Name: organization_membership_pools organization_membership_pools_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_membership_pools
    ADD CONSTRAINT organization_membership_pools_pkey PRIMARY KEY (id);


--
-- Name: organizations_history organizations_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organizations_history
    ADD CONSTRAINT organizations_history_pkey PRIMARY KEY (history_id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: person_entitlements_history person_entitlements_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_entitlements_history
    ADD CONSTRAINT person_entitlements_history_pkey PRIMARY KEY (history_id);


--
-- Name: person_entitlements person_entitlements_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_entitlements
    ADD CONSTRAINT person_entitlements_pkey PRIMARY KEY (person_id, entitlement_id);


--
-- Name: person_memberships_history person_memberships_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_memberships_history
    ADD CONSTRAINT person_memberships_history_pkey PRIMARY KEY (history_id);


--
-- Name: person_memberships person_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_memberships
    ADD CONSTRAINT person_memberships_pkey PRIMARY KEY (person_id, membership_id);


--
-- Name: person_organizations_history person_organizations_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_organizations_history
    ADD CONSTRAINT person_organizations_history_pkey PRIMARY KEY (history_id);


--
-- Name: person_organizations person_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_organizations
    ADD CONSTRAINT person_organizations_pkey PRIMARY KEY (person_id, organization_id);


--
-- Name: persons_history persons_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.persons_history
    ADD CONSTRAINT persons_history_pkey PRIMARY KEY (history_id);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (id);


--
-- Name: products_history products_history_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.products_history
    ADD CONSTRAINT products_history_pkey PRIMARY KEY (history_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_sku_key; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);


--
-- Name: stripe_events stripe_events_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.stripe_events
    ADD CONSTRAINT stripe_events_pkey PRIMARY KEY (id);


--
-- Name: stripe_events stripe_events_stripe_event_id_key; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.stripe_events
    ADD CONSTRAINT stripe_events_stripe_event_id_key UNIQUE (stripe_event_id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: mv_unified_member_person_id_idx; Type: INDEX; Schema: analytics; Owner: apiary
--

CREATE UNIQUE INDEX mv_unified_member_person_id_idx ON analytics.mv_unified_member USING btree (person_id);


--
-- Name: demo_big_commerce_orders_created_at; Type: INDEX; Schema: demo; Owner: apiary
--

CREATE INDEX demo_big_commerce_orders_created_at ON demo.big_commerce_orders USING btree (created_at);


--
-- Name: demo_big_commerce_orders_person_id; Type: INDEX; Schema: demo; Owner: apiary
--

CREATE INDEX demo_big_commerce_orders_person_id ON demo.big_commerce_orders USING btree (person_id);


--
-- Name: demo_certification_records_passed_at; Type: INDEX; Schema: demo; Owner: apiary
--

CREATE INDEX demo_certification_records_passed_at ON demo.certification_records USING btree (passed_at);


--
-- Name: demo_certification_records_person_id; Type: INDEX; Schema: demo; Owner: apiary
--

CREATE INDEX demo_certification_records_person_id ON demo.certification_records USING btree (person_id);


--
-- Name: demo_linkedin_profiles_person_id; Type: INDEX; Schema: demo; Owner: apiary
--

CREATE UNIQUE INDEX demo_linkedin_profiles_person_id ON demo.linkedin_profiles USING btree (person_id);


--
-- Name: demo_salesforce_contacts_person_id; Type: INDEX; Schema: demo; Owner: apiary
--

CREATE INDEX demo_salesforce_contacts_person_id ON demo.salesforce_contacts USING btree (person_id);


--
-- Name: contributor_engagement_occurred_at; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX contributor_engagement_occurred_at ON public.contributor_engagement USING btree (occurred_at);


--
-- Name: contributor_engagement_person_id; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX contributor_engagement_person_id ON public.contributor_engagement USING btree (person_id);


--
-- Name: contributor_engagement_source; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX contributor_engagement_source ON public.contributor_engagement USING btree (source_system, source_id);


--
-- Name: contributor_profiles_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX contributor_profiles_history_lookup ON public.contributor_profiles_history USING btree (person_id, valid_to);


--
-- Name: entitlements_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX entitlements_history_lookup ON public.entitlements_history USING btree (id, valid_to);


--
-- Name: invoices_organization_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX invoices_organization_idx ON public.invoices USING btree (organization_id);


--
-- Name: invoices_person_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX invoices_person_idx ON public.invoices USING btree (person_id);


--
-- Name: invoices_status_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX invoices_status_idx ON public.invoices USING btree (status);


--
-- Name: invoices_stripe_invoice_id_unique; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX invoices_stripe_invoice_id_unique ON public.invoices USING btree (stripe_invoice_id) WHERE (stripe_invoice_id IS NOT NULL);


--
-- Name: invoices_subscription_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX invoices_subscription_idx ON public.invoices USING btree (subscription_id);


--
-- Name: membership_plans_active_product_interval_unique; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX membership_plans_active_product_interval_unique ON public.membership_plans USING btree (product_id, billing_interval) WHERE (status = 'active'::text);


--
-- Name: membership_plans_code_unique; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX membership_plans_code_unique ON public.membership_plans USING btree (code);


--
-- Name: memberships_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX memberships_history_lookup ON public.memberships_history USING btree (id, valid_to);


--
-- Name: organization_invites_expires_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX organization_invites_expires_idx ON public.organization_invites USING btree (expires_at);


--
-- Name: organization_invites_invited_by_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX organization_invites_invited_by_idx ON public.organization_invites USING btree (invited_by_person_id);


--
-- Name: organization_invites_org_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX organization_invites_org_idx ON public.organization_invites USING btree (organization_id);


--
-- Name: organization_invites_token_unique; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX organization_invites_token_unique ON public.organization_invites USING btree (token);


--
-- Name: organization_membership_pools_active_org_product_unique; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX organization_membership_pools_active_org_product_unique ON public.organization_membership_pools USING btree (organization_id, product_id) WHERE (status = 'active'::text);


--
-- Name: organization_membership_pools_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX organization_membership_pools_history_lookup ON public.organization_membership_pools_history USING btree (id, valid_to);


--
-- Name: organization_membership_pools_org_product_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX organization_membership_pools_org_product_idx ON public.organization_membership_pools USING btree (organization_id, product_id);


--
-- Name: organizations_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX organizations_history_lookup ON public.organizations_history USING btree (id, valid_to);


--
-- Name: person_entitlements_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX person_entitlements_history_lookup ON public.person_entitlements_history USING btree (person_id, entitlement_id, valid_to);


--
-- Name: person_memberships_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX person_memberships_history_lookup ON public.person_memberships_history USING btree (person_id, membership_id, valid_to);


--
-- Name: person_organizations_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX person_organizations_history_lookup ON public.person_organizations_history USING btree (person_id, organization_id, valid_to);


--
-- Name: persons_cognito_sub_key; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX persons_cognito_sub_key ON public.persons USING btree (cognito_sub) WHERE (cognito_sub IS NOT NULL);


--
-- Name: persons_email_key; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX persons_email_key ON public.persons USING btree (lower(email)) WHERE (email IS NOT NULL);


--
-- Name: persons_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX persons_history_lookup ON public.persons_history USING btree (id, valid_to);


--
-- Name: products_history_lookup; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX products_history_lookup ON public.products_history USING btree (id, valid_to);


--
-- Name: stripe_events_status_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX stripe_events_status_idx ON public.stripe_events USING btree (status);


--
-- Name: subscriptions_organization_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX subscriptions_organization_idx ON public.subscriptions USING btree (organization_id);


--
-- Name: subscriptions_person_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX subscriptions_person_idx ON public.subscriptions USING btree (person_id);


--
-- Name: subscriptions_status_idx; Type: INDEX; Schema: public; Owner: apiary
--

CREATE INDEX subscriptions_status_idx ON public.subscriptions USING btree (status);


--
-- Name: subscriptions_stripe_subscription_id_unique; Type: INDEX; Schema: public; Owner: apiary
--

CREATE UNIQUE INDEX subscriptions_stripe_subscription_id_unique ON public.subscriptions USING btree (stripe_subscription_id) WHERE (stripe_subscription_id IS NOT NULL);


--
-- Name: contributor_profiles contributor_profiles_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER contributor_profiles_history_trigger AFTER INSERT OR UPDATE ON public.contributor_profiles FOR EACH ROW EXECUTE FUNCTION public.contributor_profiles_history_trigger_fn();


--
-- Name: entitlements entitlements_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER entitlements_history_trigger AFTER INSERT OR UPDATE ON public.entitlements FOR EACH ROW EXECUTE FUNCTION public.entitlements_history_trigger_fn();


--
-- Name: memberships memberships_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER memberships_history_trigger AFTER INSERT OR UPDATE ON public.memberships FOR EACH ROW EXECUTE FUNCTION public.memberships_history_trigger_fn();


--
-- Name: organization_membership_pools organization_membership_pools_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER organization_membership_pools_history_trigger AFTER INSERT OR UPDATE ON public.organization_membership_pools FOR EACH ROW EXECUTE FUNCTION public.organization_membership_pools_history_trigger_fn();


--
-- Name: organizations organizations_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER organizations_history_trigger AFTER INSERT OR UPDATE ON public.organizations FOR EACH ROW EXECUTE FUNCTION public.organizations_history_trigger_fn();


--
-- Name: person_entitlements person_entitlements_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER person_entitlements_history_trigger AFTER INSERT OR UPDATE ON public.person_entitlements FOR EACH ROW EXECUTE FUNCTION public.person_entitlements_history_trigger_fn();


--
-- Name: person_memberships person_memberships_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER person_memberships_history_trigger AFTER INSERT OR UPDATE ON public.person_memberships FOR EACH ROW EXECUTE FUNCTION public.person_memberships_history_trigger_fn();


--
-- Name: person_organizations person_organizations_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER person_organizations_history_trigger AFTER INSERT OR UPDATE ON public.person_organizations FOR EACH ROW EXECUTE FUNCTION public.person_organizations_history_trigger_fn();


--
-- Name: persons persons_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER persons_history_trigger AFTER INSERT OR UPDATE ON public.persons FOR EACH ROW EXECUTE FUNCTION public.persons_history_trigger_fn();


--
-- Name: products products_history_trigger; Type: TRIGGER; Schema: public; Owner: apiary
--

CREATE TRIGGER products_history_trigger AFTER INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_history_trigger_fn();


--
-- Name: big_commerce_orders big_commerce_orders_person_id_fkey; Type: FK CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.big_commerce_orders
    ADD CONSTRAINT big_commerce_orders_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: certification_records certification_records_person_id_fkey; Type: FK CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.certification_records
    ADD CONSTRAINT certification_records_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: linkedin_profiles linkedin_profiles_person_id_fkey; Type: FK CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.linkedin_profiles
    ADD CONSTRAINT linkedin_profiles_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: salesforce_contacts salesforce_contacts_person_id_fkey; Type: FK CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.salesforce_contacts
    ADD CONSTRAINT salesforce_contacts_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: salesforce_opportunities salesforce_opportunities_contact_id_fkey; Type: FK CONSTRAINT; Schema: demo; Owner: apiary
--

ALTER TABLE ONLY demo.salesforce_opportunities
    ADD CONSTRAINT salesforce_opportunities_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES demo.salesforce_contacts(id);


--
-- Name: contributor_engagement contributor_engagement_engagement_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_engagement
    ADD CONSTRAINT contributor_engagement_engagement_type_fkey FOREIGN KEY (engagement_type) REFERENCES public.engagement_types(code);


--
-- Name: contributor_engagement contributor_engagement_entitlement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_engagement
    ADD CONSTRAINT contributor_engagement_entitlement_id_fkey FOREIGN KEY (entitlement_id) REFERENCES public.entitlements(id);


--
-- Name: contributor_engagement contributor_engagement_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_engagement
    ADD CONSTRAINT contributor_engagement_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: contributor_engagement contributor_engagement_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_engagement
    ADD CONSTRAINT contributor_engagement_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: contributor_profiles contributor_profiles_contributor_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_profiles
    ADD CONSTRAINT contributor_profiles_contributor_type_fkey FOREIGN KEY (contributor_type) REFERENCES public.contributor_types(code);


--
-- Name: contributor_profiles contributor_profiles_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.contributor_profiles
    ADD CONSTRAINT contributor_profiles_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: entitlements entitlements_membership_pool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements
    ADD CONSTRAINT entitlements_membership_pool_id_fkey FOREIGN KEY (membership_pool_id) REFERENCES public.organization_membership_pools(id);


--
-- Name: entitlements entitlements_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements
    ADD CONSTRAINT entitlements_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: entitlements entitlements_origin_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements
    ADD CONSTRAINT entitlements_origin_organization_id_fkey FOREIGN KEY (origin_organization_id) REFERENCES public.organizations(id);


--
-- Name: entitlements entitlements_origin_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements
    ADD CONSTRAINT entitlements_origin_person_id_fkey FOREIGN KEY (origin_person_id) REFERENCES public.persons(id);


--
-- Name: entitlements entitlements_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements
    ADD CONSTRAINT entitlements_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: entitlements entitlements_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.entitlements
    ADD CONSTRAINT entitlements_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: invoices invoices_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: invoices invoices_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: invoices invoices_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id);


--
-- Name: membership_plans membership_plans_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.membership_plans
    ADD CONSTRAINT membership_plans_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: memberships memberships_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: memberships memberships_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: organization_invites organization_invites_invited_by_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_invites
    ADD CONSTRAINT organization_invites_invited_by_person_id_fkey FOREIGN KEY (invited_by_person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: organization_invites organization_invites_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_invites
    ADD CONSTRAINT organization_invites_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: organization_membership_pools organization_membership_pools_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_membership_pools
    ADD CONSTRAINT organization_membership_pools_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organization_membership_pools organization_membership_pools_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.organization_membership_pools
    ADD CONSTRAINT organization_membership_pools_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: person_entitlements person_entitlements_entitlement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_entitlements
    ADD CONSTRAINT person_entitlements_entitlement_id_fkey FOREIGN KEY (entitlement_id) REFERENCES public.entitlements(id) ON DELETE CASCADE;


--
-- Name: person_entitlements person_entitlements_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_entitlements
    ADD CONSTRAINT person_entitlements_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: person_memberships person_memberships_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_memberships
    ADD CONSTRAINT person_memberships_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.memberships(id) ON DELETE CASCADE;


--
-- Name: person_memberships person_memberships_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_memberships
    ADD CONSTRAINT person_memberships_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: person_organizations person_organizations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_organizations
    ADD CONSTRAINT person_organizations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: person_organizations person_organizations_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.person_organizations
    ADD CONSTRAINT person_organizations_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_membership_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_membership_plan_id_fkey FOREIGN KEY (membership_plan_id) REFERENCES public.membership_plans(id);


--
-- Name: subscriptions subscriptions_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: subscriptions subscriptions_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apiary
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: mv_active_members_by_product_month; Type: MATERIALIZED VIEW DATA; Schema: analytics; Owner: apiary
--

REFRESH MATERIALIZED VIEW analytics.mv_active_members_by_product_month;


--
-- Name: mv_entitlements_by_channel; Type: MATERIALIZED VIEW DATA; Schema: analytics; Owner: apiary
--

REFRESH MATERIALIZED VIEW analytics.mv_entitlements_by_channel;


--
-- Name: mv_organization_membership_pools; Type: MATERIALIZED VIEW DATA; Schema: analytics; Owner: apiary
--

REFRESH MATERIALIZED VIEW analytics.mv_organization_membership_pools;


--
-- Name: mv_organization_seat_summary; Type: MATERIALIZED VIEW DATA; Schema: analytics; Owner: apiary
--

REFRESH MATERIALIZED VIEW analytics.mv_organization_seat_summary;


--
-- Name: mv_unified_member; Type: MATERIALIZED VIEW DATA; Schema: analytics; Owner: apiary
--

REFRESH MATERIALIZED VIEW analytics.mv_unified_member;


--
-- PostgreSQL database dump complete
--

\unrestrict Qu2LmmGII1mu6OzqYXfos3rWVFwXecE1gjYrAPdVFULrTIaVS7FTePi2x0bgGim

